require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:hannah)
    @other_user = users(:schooley)
  end

  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end
end
