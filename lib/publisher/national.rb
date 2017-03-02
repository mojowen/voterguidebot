module Publisher
  class National < AVG

    def resource
      "https://#{bucket}"
    end

    def namespace
      Dir.glob("app/views/templates/avg/subpages/*.html.haml")
         .map { |f| f.split('/').last.split('.').first } + %w(assets index.html)
    end

    private

    def generate
      FileUtils.mkdir_p asset_path
      render_index
      render_contests
      sync_assets
      invalidate_assets
    end

    def render_index
      render_static 'index.html'
      cloudfront.add_path("/index.html")
    end
  end
end
