require 'test_helper'

class PaysControllerTest < ActionController::TestCase
  test "should get fail" do
    get :fail
    assert_response :success
  end

  test "should get success" do
    get :success
    assert_response :success
  end

  test "should get pay" do
    get :pay
    assert_response :success
  end

end
