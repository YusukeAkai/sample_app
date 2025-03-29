class SessionsController < ApplicationController
  def new; end

  def create
    # loginしたときに実行されるメソッド
    # 正しいメールアドレスとパスワードが入力されたときにuserのページにリダイレクトされる。
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
      else
        message  = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
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
