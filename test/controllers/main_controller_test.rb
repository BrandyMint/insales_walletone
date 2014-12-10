require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get instruction' do
    get :instruction
    assert_response :success
  end

end
