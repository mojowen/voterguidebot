module Publisher
  class Base
    attr_reader :guide, :template

    def initialize(guide)
      @guide = guide
      @template = guide.template
    end

    def publish
      generate
      complete
    rescue StandardError => error
      cancel
      raise error
    end

    def resource
      nil
    end

    def s3_key
      nil
    end

    def published_resource
      resource
    end

    def is_publishing?
      guide.published_version == 'publishing'
    end

    def is_failed?
      guide.published_version == 'publishing-failed'
    end

    def is_unpublished?
      guide.published_version == 'unpublished'
    end

    def is_published?
      !is_failed? && !is_publishing? && !is_unpublished? && resource
    end

    def is_synced?
      guide.published_version == guide.version
    end

    private

    def generate
      raise '#generate method must be overwritten'
    end

    def clean
      nil
    end

    def complete
      guide.update_attributes published_version: guide.version,
                              published_at: Time.current
      clean
    end

    def cancel
      guide.update_attributes published_version: 'publishing-failed'
      clean
    end
  end
end
