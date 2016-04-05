require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Schooley", email: "schooley@cats.com", handle: "schooley", password: "meow", password_confirmation: "meow")
  end

  test "should be valid" do
    assert @user.valid?
  end
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  test "handle should be present" do
    @user.handle = ""
    assert_not @user.valid?
  end
  test "should follow and unfollow a user" do
    hannah = users(:hannah)
    schooley  = users(:schooley)
    assert_not hannah.following?(schooley)
    hannah.follow(schooley)
    assert hannah.following?(schooley)
    assert schooley.followers.include?(hannah)
    hannah.unfollow(schooley)
    assert_not hannah.following?(schooley)
  end
end
