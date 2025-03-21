class SessionsController < ApplicationController
  def new; end

  def create
    # loginしたときに実行されるメソッド
    # 正しいメールアドレスとパスワードが入力されたときにuserのページにリダイレクトされる。
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # module SessionsHelperのrememberヘルパーメソッドを呼び出す
      log_in @user
      # module SessionsHelperのlog_inメソッドを呼び出す
      # メソッド内では、userのidがsession[:user_id]に代入される
      # ブラウザ内の一時cookiesに暗号化されたユーザーIDが自動的に作成される。
      redirect_to forwarding_url || @user
      # redirect_to user_url(@user) と同等のコード
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    # ヘルパーメソッドのlog_outを呼び出す
    # セッションがリセットされる。
    redirect_to root_url, status: :see_other
    # httpのステータスは303 See Other
  end
end
