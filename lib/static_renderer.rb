class StaticRender < ActionController::Base
  def self.render_file(filename, *args)
    html = render_html(*args)
    file = Rails.root.join('public', "#{filename}.html")

    File.open(file, 'w+') { |file| file.write(html) }
  end

  def self.render_html(template_path, params, layout = nil)
    view.render(file: "#{template_path}.html.haml", locals: params, layout: layout)
  end

  def self.view
    @view ||= begin
      view = ActionView::Base.new(ActionController::Base.view_paths, {})
      class << view
        include ApplicationHelper
        include AvgHelper
      end
      view
    end
  end

end
