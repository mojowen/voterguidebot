require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(*Rails.groups)

require File.expand_path('../../lib/env_loader', __FILE__)
require 'shrimp'

module VoterGuideBot
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.before_configuration { env_loader('.env', Rails.root) }
    config.generators{ |g| g.test_framework :rspec, fixture: true }
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|  html_tag }
    config.react.variant = :production
    config.react.addons  = true
    config.i18n.enforce_available_locales = false

    # config.middleware.use Shrimp::Middleware, {
    #                                             polling_interval: 1,
    #                                             polling_offset: 5,
    #                                             cache_ttl: 3600,
    #                                             out_path: Rails.root.join('public')
    #                                           },
    #                                           only: %r(/guides/\d+/preview)
  end
end
