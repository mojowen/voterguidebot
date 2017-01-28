class MoveToLegacyTemplates < ActiveRecord::Migration
  def up
    Guide.all.each do |guide|
      guide.update_attributes template_name: "archived/2016_#{guide.template_name}"
    end
  end
end
