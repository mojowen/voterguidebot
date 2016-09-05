class StaticRenderer < ActionController::Base
  def self.render_file(rendered_file, *args)
    html = render_html(*args)
    File.open(Rails.root.join(rendered_file), 'w:utf-8') { |file| file.write(html) }
  end

  def self.render_html(template_path, params, layout = nil)
    view.render(file: template_path, locals: params, layout: layout)
  end

  def self.view
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view
      include ApplicationHelper
      include GuideHelper
      include AvgHelper
    end
    view
  end
end
