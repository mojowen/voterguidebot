module Publisher
  class Innactive < Base
    def publish
      cancel
    end
  end
end
