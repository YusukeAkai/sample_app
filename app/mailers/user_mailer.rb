class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Account activation'
    # user = User.first
    # ここのsubjectがメールの要件に相当する。
  end

  def password_reset
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end
end
