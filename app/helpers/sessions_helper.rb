module SessionsHelper

  # コントローラで使用するためのヘルパーメソッド

  
  def current_user

    if (user_id = session[:user_id])
      # 比較ではない。　user_idにsession[:user_id]を代入している。
      # user_idのセッションが存在すればtrueを返す

      user = User.find_by(id: session[:user_id])
      # @current_userがnilであれば
      # User.find_by(id: session[:user_id])を@current_userに代入する
       if user && session[:session_token] == user.session_token
         @current_user = user
       end

    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: cookies.encrypted[:user_id])
      # 自動的にユーザーIDのcookies暗号が解除され、元に戻る。
      # id: cookies.encrypted[:user_id]ここは普通のIDに対応している。
      if user&.authenticated?(cookies[:remember_token])
        # パスワードで設定したauthenticateメソッドとは異なる点に注意
        # オリジナルで設定したメソッドで、Modelのuser.rbに記述してある。
        log_in user
        @current_user = user
      end
    end
  end

  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end


  def logged_in?
    !current_user.nil?
    # ここで、current_userメソッドを呼び出して、返り値が空ではない時にtrueを返す。
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
    # 安全のため
  end

  def remember(user)
    user.remember
    # ここで、modelディレクトリにあるrememberメソッドを呼び出している。
    # remember_digestが更新される。
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    # cookieへの書き込みが行われている。
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
