module Publisher
  class AVG < Base

    private

    def collect_and_sync_assets
    end

    def collect_assets
    end

    def sync_assets
      assets.each do |asset|
        s3.upload_if_changed asset
      end
    end

    def clean_assets
    end

    def render_contest_shareables
    end

    def s3
      @s3_uploader ||= S3Uploader.new ENV['AVG_BUCKET'] || 'preview.americanvoterguide.org'
    end

    def generate
      collect_and_sync_assets
    end

    def clean
      clean_assets
    end
  end
end
