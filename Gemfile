source 'https://rubygems.org'

gem 'rails', '4.1.8'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'haml-rails'
gem 'configus'
gem 'insales_api'
gem 'httparty'

gem 'dotenv-rails', groups: [:development, :test]

group :development do
  gem 'spring'
  gem 'pry'
  gem 'awesome_print'
  gem 'rubocop'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

group :test do
  gem 'vcr'
  gem 'wrong'
  gem 'webmock'
  gem 'simplecov', require: false
end

group :deploy do
  gem 'capistrano', '~> 3.1', :require => false
  gem 'capistrano-rbenv', '~> 2.0',  :require => false
  gem 'capistrano-rails', '~> 1.1', :require => false
  gem 'capistrano-bundler', :require => false
  gem "capistrano-db-tasks", :require => false
  gem "capistrano-stats"
end
