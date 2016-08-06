class Guide < ActiveRecord::Base
  audited
  has_associated_audits

  has_many :permissions
  has_many :users, through: :permissions
  has_many :contests, -> { order(position: :asc) }
  has_many :measures, -> { order(position: :asc) }
  has_many :languages
  has_many :uploads
  has_many :fields
  has_one :location

  accepts_nested_attributes_for :location

  validates :name, presence: true
  validates :location, presence: true
  validates :election_date, presence: true

  def template
    @template ||= Template.default
  end

  def publish(force = false)
    Publisher.new(as_json, template.make, version).publish

    # TODO: Handle multi-lingual
    # create workspace
    # create website with all languages using dom-i18n
    # create pdf with all languages
    # maybe doesn't need to live in guide model - maybe something else
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
      field.save!
    end
  end

  def version
    @version ||= Digest::MD5.hexdigest to_json
  end

  def field(template_name)
    find_field(template_name).try(:value)
  end

  private

  def find_field(template_name)
    fields.find { |field| field.field_template == template_name  }
  end

  def universal_field(field)
    Globalize.with_locale(:en) { field.try(:value) }
  end

  def field_value(template_field)
    field = find_field(template_field['name'])
    return universal_field(field) if template_field['element'] == 'ImageComponent'
    field.try(:value)
  end
end
