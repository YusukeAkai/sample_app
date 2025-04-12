class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    # セッション変数にforwarding_urlを保存する。
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
    # おそらくこの行を編集する。
  end
end
