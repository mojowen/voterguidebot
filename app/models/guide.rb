class Guide < ActiveRecord::Base
  audited
  has_associated_audits

  has_many :permissions
  has_many :users, through: :permissions
  has_many :contests

  has_many :fields

  validates :name, presence: true

  def template
    @template ||= Template.default
  end

  def template_fields
    template.fields.map do |template_field|
      template_field[:value] = find_field(template_field[:name]).try(:value)
      template_field
    end
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
end
