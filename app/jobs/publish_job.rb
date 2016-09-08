class PublishJob < ApplicationJob
  attr_accessor :object_to_be_published

  def initialize(object_to_be_published)
    @object_to_be_published = object_to_be_published
  end

  def perform
    object_to_be_published.publish
  end

  def max_attempts
    1
  end
end
