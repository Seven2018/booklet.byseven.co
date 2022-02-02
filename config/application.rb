require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
require 'bundler'
Bundler.require(*Rails.groups)

module BookletBysevenCo
  class Application < Rails::Application

    config.generators do |generate|
          generate.assets false
          generate.helper false
          generate.test_framework  :test_unit, fixture: false
        end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_job.queue_adapter = :sidekiq
    RenderAsync.configure do |config|
      jquery = true # This will render jQuery code, and skip Vanilla JS code
    end

    # config.action_mailer.default_url_options = { host: ENV['APP_DOMAIN'] }
    config.action_mailer.default_url_options = { host: 'https://seven-booklet.herokuapp.com' }
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { api_token: ENV['POSTMARK_API_TOKEN'] }
  end
end
