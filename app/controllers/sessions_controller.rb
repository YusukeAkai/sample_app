class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      reset_session
      # ログインする際に、セッション固定と呼ばれる攻撃を防ぐためのコード
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # module SessionsHelperのrememberヘルパーメソッドを呼び出す
      log_in @user
      # module SessionsHelperのlog_inメソッドを呼び出す
      # メソッド内では、userのidがsession[:user_id]に代入される
      # ブラウザ内の一時cookiesに暗号化されたユーザーIDが自動的に作成される。
      redirect_to @user
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      # redirect_to user_url(user) と同等のコード
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
