class UserMailer < ApplicationMailer
  default from: 'CharmaApp@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Charma!')
  end

  def password_reset(user)
    @user = user
    @random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    @user.password = @random_password
    @user.save!

    mail :to => user.email, :subject => "Password Reset"
  end

end
