require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get manual' do
    get :manual
    assert_response :success
  end

end
