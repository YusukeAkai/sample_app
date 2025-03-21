module SessionsHelper
  # コントローラで使用するためのヘルパーメソッド

  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      @current_user = user if user && session[:session_token] == user.session_token
    elsif cookies.encrypted[:user_id]
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

  def current_user?(user)
    user == current_user
    # true or false
    # ここで、current_userメソッドを呼び出して、返り値が引数と一致しているかを確認
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

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
    # request.original_urlはリクエストが送られたURLを返す
    # リクエストがGETの場合、session[:forwarding_url]にリクエストが送られたURLを保存する
    # リクエストがGETなのは、editやshowといったリクエストに対応しており、
  end
end
