require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    # ログインしていない状態で、editアクションを実行
    assert flash.empty?
    # フラッシュメッセージが空でないことを確認
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect index when not logged in' do
    get users_path
    # これがユーザーの詳細ページへのアクセス
    # 自動的に定義されていたindexアクションを実行している。
    assert_redirected_to login_url
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    # falseだったらOK
    patch user_path(@other_user),
          params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
    assert_not @other_user.reload.admin?
    # adminがfalseの時にPASSする。
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference('User.count') do
      # ログインしていない
      # ユーザー数が変化していないかをテストしている。
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    # admin権限がないユーザーでログイン
    assert_no_difference('User.count') do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
