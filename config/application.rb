require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Halfsavage
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :en
    config.secret_key_base = 'fartbanger' # this should probably be something besides 'fartbanger'

    # There's a bug with schema_format = :sql in 4.0.0 thru 4.0.3
    # It always defaults to :ruby during rake:db:schema:dump
    # ref: https://github.com/rails/rails/pull/13312
    # workaround: "rake db:rollback; rake db:migrate" will correctly produce a sql, not ruby, DB dump
    # Should be fixed in 4.0.4
    # UPDATE: Nope, still not fixed in 4.0.4 even though the above pull request was merged
    config.active_record.schema_format = :sql
    ActiveRecord::Base.schema_format = config.active_record.schema_format

    # allow devise to login via either username or email
    # also need to override find_for_authentication in member.rb
    # and also need to change calls to devise_parameter_sanitizer in member.rb
    # ref: http://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
    # also ref: https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-sign-in-using-their-username-or-email-address
    config.authentication_keys = [ :email, :username ]

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
