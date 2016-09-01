module Publisher
  class Conducter
    def self.publish(guide_id)
      guide = Guide.find(guide_id)

      publish_class = Object.const_get("Publisher::#{guide.template.publisher_class}")
      publish_class.new(guide).publish
    end
  end
end
