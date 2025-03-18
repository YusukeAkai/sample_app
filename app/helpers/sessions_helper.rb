module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      # session[:user_id]が存在する場合、
      @current_user ||= User.find_by(id: session[:user_id])
      # @current_userがnilであれば
      # User.find_by(id: session[:user_id])を@current_userに代入する
    end
  end

  def logged_in?
    !current_user.nil?
    # ここで、current_userメソッドを呼び出して、空ではない時にtrueを返す。
  end

  def log_out
    reset_session
    @current_user = nil
    # 安全のため
  end

end
