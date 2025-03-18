require "test_helper"

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
    # fixtureにあるmichaelをdbとcookie（idと記憶トークン、記憶ダイジェスト）に保存する。
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    # current_userメソッドでsessionはnilに設定。
    # elseifは通る。
    assert is_logged_in?
    # ログインできているかをテスト。
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    # setupですでに記憶ダイジェストを設定しているが、あえて記憶ダイジェストのみを更新する。
    assert_nil current_user
    # user&.authenticated?(cookies[:remember_token])
    # ここで、authenticated?がfalseになるため、current_userはnilになる。
    # 理由としては、記憶ダイジェストが変更されているため。記憶トークンとダイジェストが合わない。
  end
end
