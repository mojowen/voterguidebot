module Publisher
  class Conducter
    attr_reader :guide

    def initialize(guide)
      @guide = guide
    end

    def publish
      publisher.publish
    end

    def resource
      publisher.resource
    end

    private

    def publisher
      @publisher ||= publisher_class.new(guide)
    end

    def publisher_class
      Object.const_get("Publisher::#{guide.template.publisher_class}")
    end
  end
end
