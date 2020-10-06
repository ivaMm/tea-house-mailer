class TeaMailer < ApplicationMailer
   def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Hello from TeaHouse!')
  end
end
