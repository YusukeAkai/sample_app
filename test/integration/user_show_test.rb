require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @inactive_user  = users(:inactive)
    @activated_user = users(:archer)
  end

  test 'should redirect when user not activated' do
    log_in_as(@inactive_user)
    get user_path(@inactive_user)
    assert_response      :redirect
    assert_redirected_to root_url
  end

  test 'should display user when activated' do
    log_in_as(@activated_user)
    get user_path(@activated_user)
    assert_response :success
    assert_template 'users/show'
  end
end
