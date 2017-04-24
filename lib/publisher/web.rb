module Publisher
  class Web < AVG

    def resource
      "http://#{bucket}/#{slug}"
    end

    def namespace
      slug
    end

    def slug
      @slug ||= guide.field('voter_guide_url').try!(:strip) || guide.slug
    end

    private

    def generate
      FileUtils.mkdir_p web_path
      render_state
      render_share_image
      render_contests
      render_measures
      sync_assets
      invalidate_assets
    end

    def render_state
      render_static Rails.root.join(web_path, "index.html").to_s
      cloudfront.add_path("/#{slug}/index.html")
      cloudfront.add_path("/#{slug}/")
    end

    def web_path
      Rails.root.join(root_path, slug)
    end

    def render_share_image
      render_image Rails.root.join(web_path, "share").to_s, 'web_img', guide: guide
      cloudfront.add_path("/#{slug}/share.png")
    end
  end
end
