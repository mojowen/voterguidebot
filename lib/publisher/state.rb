module Publisher
  class State < AVG

    def resource
      "http://#{bucket}/#{guide.location.state_slug}"
    end

    private

    def generate
      render_state
      render_share_image
      render_contests
      sync_assets
    end

    def render_state
      state_path = Rails.root.join(root_path, guide.location.state_slug)
      FileUtils.mkdir_p state_path
      render_static Rails.root.join(state_path, "index.html").to_s
    end

    def render_share_image
      render_image 'share', 'state_img', guide: guide
    end
  end
end
