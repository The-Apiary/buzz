require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "Should create a cookie for the user with the passed hash" do
    user = create(:user)
    get :create, {id_hash: user.id_hash}
    assert_redirected_to root_url
    assert_equal user.id_hash, cookies[:auth_token]
  end

  test "Should delete a cookie on logout" do
    user = create(:user)
    signin user
    assert_equal user.id_hash, cookies[:auth_token]
    get :destroy
    assert_redirected_to root_url
    assert_equal nil, cookies[:auth_token]
  end


  # I'm not sure how to test this.
  # test "Should test facebook login"
end
