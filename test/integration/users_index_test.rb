require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @users = users(:michael)
    @other_user = users(:archer)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@users)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', 2
    # divタグのpaginationクラス
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: 'delete' unless user == @users
      # admin権限のあるユーザーがログインした場合に、deleteリンクが表示されるかをテスト
    end
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end
  test 'index as non-admin' do
    log_in_as(@other_user)
    get users_path
    assert_select 'aaa', text: 'delete', count: 0
  end
end
