class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Account activation'
    # user = User.first
    # ここのsubjectがメールの要件に相当する。
  end

  def password_reset(user)
    @user = user
    # なんでここで，@userを定義しているのか？
    mail to: user.email, subject: 'Password reset'
  end
end
