require 'digest'
require 'aws-sdk'

class CloudfrontWrapper

  def initialize(distribution, caller_reference = nil)
    @distribution = distribution
    @caller_reference = caller_reference
    @paths = []
  end

  def add_path(path)
    paths << validate_path!(path)
  end

  def invalidate!
    cloudfront.create_invalidation({
      distribution_id: distribution,
      invalidation_batch: {
        paths: {
          quantity: paths.count,
          items: paths,
        },
        caller_reference: caller_reference || "#{Time.current.iso8601}-this-was-not-set"
      }
    })
  end

  private

  attr_accessor :paths, :distribution, :caller_reference

  def validate_path!(path)
    raise "Invalid Path `#{path}`" if path[0] != '/'
    path
  end

  def cloudfront
    @cloudfront ||= Aws::CloudFront::Client.new( region: ENV.fetch('AWS_REGION') )
  end
end

