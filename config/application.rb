require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(*Rails.groups)

require File.expand_path('../../lib/env_loader', __FILE__)

module VoterGuideBot
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.before_configuration { env_loader('.env', Rails.root) }
    config.generators{ |g| g.test_framework :rspec, fixture: true }
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|  html_tag }
    config.react.variant = :production
    config.react.addons  = true
    config.i18n.enforce_available_locales = false
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
