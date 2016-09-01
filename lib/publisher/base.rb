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
      abort
      raise error
    end

    private

    def generate
      raise '#generate method must be overwritten'
    end

    def complete
      guide.update_attributes published_version: guide.version,
                              published_at: Time.current
      clean
    end

    def abort
      guide.update_attributes published_version: 'publishing-failed'
      clean
    end

    def clean
      raise '#generate method must be overwritten'
    end
  end
end
