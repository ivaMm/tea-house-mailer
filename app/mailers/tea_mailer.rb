class TeaMailer < ApplicationMailer
   def welcome_email(user)
    @user = user
    mail(
      from: "Tea House",
      to: @user.email,
      subject: 'Hello from TeaHouse!') do |format|
        format.html { render 'welcome_email.html.erb' }
        format.text { render plain: 'welcome_email.text.erb' }
      end
  end
end
