module Publisher
  class National < AVG

    def resource
      "http://#{bucket}"
    end

    private

    def generate
      StaticRenderer.render_file Rails.root.join(root_path, 'index.html'),
                                 template.template_file_path(template.view),
                                 { guide: guide, preview: false },
                                 'layouts/avg.html.haml'
      super
    end
  end
end
