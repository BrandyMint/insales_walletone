require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module W1InsalesApp
  class Application < Rails::Application
    config.autoload_paths += Dir[ "#{config.root}/lib/**/" ]
    config.time_zone = 'Moscow'

    config.generators do |g|
      g.template_engine :haml
      g.stylesheets false
      g.javascripts false
      g.helper false
    end
  end
end
