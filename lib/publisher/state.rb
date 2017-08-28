module Publisher
  class State < AVG

    def resource
      "https://#{bucket}/#{slug}"
    end

    def namespace
      slug
    end

    def slug
      @slug ||= guide.location.state_slug
    end

    private

    def generate
      FileUtils.mkdir_p state_path
      render_state
      render_share_image
      render_contests
      render_measures
      sync_assets
      invalidate_assets
    end

    def render_state
      render_static Rails.root.join(state_path, "index.html").to_s
      cloudfront.add_path("/#{slug}/index.html")
      cloudfront.add_path("/#{slug}/")
    end

    def state_path
      Rails.root.join(root_path, slug)
    end

    def render_share_image
      render_image Rails.root.join(state_path, "share").to_s, 'state_img', guide: guide
      cloudfront.add_path("/#{slug}/share.png")
    end
  end
end
