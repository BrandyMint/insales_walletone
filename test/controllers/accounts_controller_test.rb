require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  test "should get install" do
    get :install
    assert_response :success
  end

  test "should get uninstall" do
    get :uninstall
    assert_response :success
  end

end
