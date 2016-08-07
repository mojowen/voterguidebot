class AddTemplateToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :template_name, :string, default: :default
  end

  def up
    Guide.update_all template_name: 'default'
  end
end
