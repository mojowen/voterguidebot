module Publisher
  class Conducter

    attr_reader :publisher

    def initialize(guide)
      @publisher = publisher_class(guide).new(guide)
    end

    def method_missing(method_name, *arguments, &block)
      unless publisher.respond_to? method_name
        raise "Publisher::#{guide.template.publisher_class} does not implement #{method_name}"
      end
      publisher.send(method_name, *arguments, &block)
    end

    private

    def publisher_class(guide)
      Object.const_get("Publisher::#{guide.template.publisher_class}")
    end
  end
end
