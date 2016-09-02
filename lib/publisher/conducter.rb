module Publisher
  class Conducter

    attr_reader :publisher

    def initialize(guide)
      @publisher = publisher_class(guide).new(guide)
    end

    def method_missing(method_name, *arguments, &block)
      publisher.send(method_name, *arguments, &block)
    end

    private

    def publisher_class(guide)
      Object.const_get("Publisher::#{guide.template.publisher_class}")
    end
  end
end
