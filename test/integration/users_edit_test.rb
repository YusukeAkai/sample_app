require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    patch user_path(@user), params: { user: { name: 'Foo Bar',
                                              email: 'example@example.com',
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    # showアクションのusers/(id)　にリダイレクトされている。
    @user.reload
    assert_equal 'Foo Bar', @user.name
    assert_equal 'example@example.com', @user.email
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_select 'div.alert', 'The form contains 4 errors.'
    assert_template 'users/edit'
  end
end
