class Guide < ActiveRecord::Base
  audited
  has_associated_audits

  has_many :permissions
  has_many :users, through: :permissions
  has_many :contests, -> { order(position: :asc) }
  has_many :measures, -> { order(position: :asc) }
  has_many :languages
  has_many :uploads
  has_many :fields, autosave: true
  has_one :location

  accepts_nested_attributes_for :location

  validates :name, presence: true
  validates :location, presence: true
  validates :template_name, presence: true
  validates :election_date, presence: true

  def template
    @template ||= Template.new template_name
  end

  def slug
    [id,  name.gsub(/\s/, '-').downcase.gsub(/[^\w-]/, '').downcase].join('-')
  end

  def publish
    publisher.publish
  end

  def published_resource
    publisher.resource
  end

  def is_publishing?
    published_version == 'publishing'
  end

  def is_published?
    !%w{publishing-failed unpublished publishing}.include?(published_version) && published_resource
  end

  def is_synced?
    published_version == version
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

  def as_json(options = nil)
    super({
      include: {
        location: nil,
        fields: nil,
        languages: nil,
        contests: {
          include: { candidates: { include: :endorsements },
                     questions: { include: [:answers, :tags] }}},
        measures: { include: [:endorsements, :tags] }} }.update(options || {}))
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
    count = send(type).count + check_size
    options = template.send(type)['per_page']
    per_page = options.is_a?(Integer) ? options : options['values'][field(options['key'])]
    count * per_page
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
      to_json(except: [:updated_at, :created_at, :published_at,
                       :published_version, :users, :permissions, :uploads])
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
