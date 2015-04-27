require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(*Rails.groups)

module W1InsalesApp
  class Application < Rails::Application
    config.autoload_paths += Dir[
      Rails.root.join('lib'),
      Rails.root.join('app/errors'),
      Rails.root.join('app/form_objects'),
      Rails.root.join('app/middlewares'),
      Rails.root.join('app/services')
    ]

    config.time_zone = 'Moscow'

    config.generators do |g|
      g.template_engine :haml
      g.stylesheets false
      g.javascripts false
      g.helper false
    end
  end
end
