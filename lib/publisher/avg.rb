module Publisher
  class AVG < Base

    def initialize(guide)
      super(guide)
      @asset_path = Rails.root.join(root_path, 'assets')
      FileUtils.mkdir_p asset_path
    end

    private

    attr_reader :asset_path

    def render_static(rel_path_to_file)
      StaticRenderer.render_file Rails.root.join(root_path, rel_path_to_file),
                                 template.template_file_path(template.view),
                                 { guide: guide, preview: false },
                                 'layouts/avg.html.haml'
    end

    def sync_assets
      s3.upload_directory root_path
    end

    def clean_assets
      FileUtils.remove_dir root_path
    end

    def s3
      @s3_uploader ||= S3Uploader.new bucket
    end

    def bucket
      ENV['AVG_BUCKET'] || 'preview.americanvoterguide.org'
    end

    def root_path
      @root_path ||= Rails.root.join('tmp', Time.now.getutc.to_i.to_s, 'avg')
    end

    def clean
      clean_assets
    end
  end
end
