class Guide < ActiveRecord::Base
  audited
  has_associated_audits

  has_many :permissions
  has_many :users, through: :permissions
  has_many :contests
  has_many :measures
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

  def template_fields
    template.fields.map do |template_field|
      template_field = template_field.clone
      template_field[:value] = field_value template_field
      template_field
    end
  end

  def template_questions
    template.question_seeds.map.with_index do |question, index|
      question = Question.new text: question['text'],
                              tags: [ Tag.new(name: question['tag'] )]
      question.as_json(include: :tags).update('id' => "#{index}question")
    end
  end

  def template_question_tags
    template.question_tags
  end

  def template_field_names
    template.fields.map{ |template_field| template_field[:name] }
  end

  def template_fields=(fields_obj)
    template.fields.each do |template_field|
      value = fields_obj[template_field[:name]]
      next if value.nil? || value.empty?

      field = find_field(template_field[:name])
      field ||= fields.new(field_template: template_field[:name])
      field.value = value
      field.save!
    end
  end

  private

  def find_field(template_name)
    fields.find { |field| field.field_template == template_name  }
  end

  def universal_field(field)
    Globalize.with_locale(:en) { field.try(:value) }
  end

  def field_value(template_field)
    field = find_field(template_field[:name])
    return universal_field(field) if template_field[:element] == 'ImageComponent'
    field.try(:value)
  end
end
