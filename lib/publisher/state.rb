module Publisher
  class State < AVG

    def resource
      "htttp://#{bucket}/#{guide.location.state_slug}"
    end

    private

    def generate
      state_path = Rails.root.join(root_path, guide.location.state_slug)
      FileUtils.mkdir_p state_path
      render_static Rails.root.join(state_path, "index.html").to_s
      sync_assets
    end
  end
end
