class Guide < ActiveRecord::Base
  audited
  has_associated_audits

  has_many :permissions, dependent: :destroy
  has_many :export_guides, dependent: :destroy
  has_many :users, through: :permissions
  has_many :contests, -> { order(position: :asc) }, dependent: :destroy
  has_many :measures, -> { order(position: :asc) }, dependent: :destroy
  has_many :uploads
  has_many :fields, autosave: true
  has_one :location
  has_many :languages

  accepts_nested_attributes_for :location

  validates :name, presence: true
  validates :location, presence: true
  validates :template_name, presence: true
  validates :election_date, presence: true

  delegate :publish, :published_resource, :is_publishing?, :is_failed?,
           :is_published?, :is_synced?, :s3_key, :namespace, to: :publisher

  def template
    @template ||= Template.new template_name
  end

  scope :full_scoped, -> () {
    includes(
      fields: [:translations],
      measures: {
        translations: nil,
        endorsements: [:translations]
      },
      contests: {
        translations: nil,
        answers: [:translations],
        candidates: [:translations],
        questions: [:translations],
        endorsements: [:translations]
      }
    )
  }

  scope :index_scoped, -> () {
    includes(:location,
              fields: [:translations])
    .joins("LEFT JOIN contests ON contests.guide_id = guides.id")
    .joins("LEFT JOIN measures ON measures.guide_id = guides.id")
    .group("guides.id")
    .select('count(measures.id) as measures_count,
             count(contests.id) as contests_count,
             guides.*')
  }

  def start_publishing
    update_attributes published_version: 'publishing'
    Delayed::Job.enqueue PublishJob.new(self)
  end

  def slug
    [id, name.strip.downcase.gsub(/\s/, '-').gsub(/[^\w-]/, '')].join('-')
  end

  def slim_json
    as_json(only: [:name, :id])
  end

  def full_clone
    cloned = dup
    cloned.contests = contests.map(&:full_clone)
    cloned.measures = measures.map(&:full_clone)
    cloned.users = users
    cloned.template_fields = Hash[template_fields.map do |field|
      [field['name'], field['value']]
    end]
    cloned
  end

  def all_locales
    base = as_json
    return base if languages.empty?

    base['languages'].map! do |language|
      language['guide'] = Globalize.with_locale(language['code']) { as_json }
      language
    end

    base
  end

  def finished_field_values
    template_fields.map { |field| field['value'] }.reject(&:nil?)
  end

  def template_fields
    template.fields.map do |template_field|
      template_field = template_field.clone
      template_field['value'] = field_value template_field
      template_field
    end
  end

  def template_field_names
    template.fields.map{ |template_field| template_field['name'] }
  end

  def template_fields=(fields_obj)
    template.fields.each do |template_field|
      value = fields_obj[template_field['name']]
      next if value.nil? || value.empty?

      field = find_field(template_field['name'])
      field ||= fields.new(field_template: template_field['name'])
      field.value = value
    end
  end

  def pages_for(type, check_size: 0)
    count = (respond_to?("#{type}_count") ? send("#{type}_count") : send(type).count) + check_size
    options = template.send(type)['per_page']
    if options.is_a?(Float) || options.is_a?(Integer)
      per_page = options
    else
      per_page = options['values'][field(options['key'])]
    end
    (count * per_page).ceil
  end

  def total_pages
    pages_for(:contests) + pages_for(:measures) + template.filler_pages
  end

  def is_there_space?(contests: 0, measures: 0)
    check_pages = pages_for(:contests, check_size: contests) + pages_for(:measures, check_size: measures)
    check_pages <= template.available_pages
  end

  def version
    @version ||= Digest::MD5.hexdigest(
      to_json(
        except: [:updated_at, :created_at, :published_at,
                 :published_version, :users, :permissions, :uploads],
        include: {
          measures: {
            only: [:title, :description, :yes_means, :no_means, :stance, :position],
            include: {
              endorsements: { only: :endorser },
              tags: { only: :name }
            }
          },
          contests: {
            only: [:title, :description, :position],
            include: {
              candidates: {
                only: [:photo, :name, :bio, :facebook, :website, :twitter, :party, :position],
                include: { endorsements: { only: :endorser } }
              },
              questions: {
                only: [:text, :position],
                include: {
                  answers: { only: [:text, :candidate_id] },
                  tags: { only: :name }
                }
              }
            }
          }
        },
        methods: :template
      )
    )
  end

  def field(template_name)
    val = find_field(template_name).try(:value)
    return val if val && !val.empty?
    find_template_field(template_name).try(:fetch, 'default', '')
  end

  private

  def publisher
    @publisher ||= Publisher::Conducter.new(self)
  end

  def find_template_field(template_name)
    template_fields.find { |fd| fd["name"]  == template_name }
  end

  def find_field(template_name)
    fields.find { |field| field.field_template == template_name  }
  end

  def universal_field(field)
    Globalize.with_locale(:en) { field.try(:value) }
  end

  def field_value(template_field)
    field = find_field(template_field['name'])
    return universal_field(field) if template_field['element'].match /image|select/
    field.try(:value)
  end
end
