ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock'
WebMock.disable_net_connect!
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
end

class ActiveSupport::TestCase
  include Wrong
  Wrong.config.color
  include WebMock::API
  fixtures :all

end
