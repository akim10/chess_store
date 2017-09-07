require 'test_helper'

class OrderItemControllerTest < ActionController::TestCase
  test "should get shipped" do
    get :shipped
    assert_response :success
  end

  test "should get unshipped" do
    get :unshipped
    assert_response :success
  end

  test "should get toggle" do
    get :toggle
    assert_response :success
  end

end
