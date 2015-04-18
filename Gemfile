source 'https://rubygems.org'

gem 'rails',   '4.2.1'
gem 'pg',      '~> 0.18.1'
gem 'sqlite3', '~> 1.3.10'

# core
gem 'insales_api',   '~> 0.0.13'
gem 'walletone',     '~> 0.1.2'
gem 'settingslogic', '~> 2.0.9'
gem 'httparty',      '~> 0.13.3'
gem 'virtus',        '~> 1.0.5'

# assets
gem 'sass-rails',  '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'jquery-rails'
gem 'haml-rails'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'pry-rails',   '~> 0.3.3'

  gem 'quiet_assets'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.2.1'
  gem 'webmock',     '~> 1.21.0'
  gem 'fabrication', '~> 2.12.2'
  gem 'ffaker',      '~> 2.0.0'
  gem 'database_cleaner'
end

group :deploy do
  gem 'capistrano', '~> 3.1', require: false
  gem 'capistrano-rbenv', '~> 2.0',  require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-stats'
end
