class TeaMailer < ApplicationMailer
   def welcome_email(user)
    @user = user
    mail(
      from: "Tea House<teahouseteam@teahouse.space>",
      to: @user.email,
      subject: 'Hello from TeaHouse!') do |format|
        format.html { render 'welcome_email.html.erb' }
        format.text { render plain: 'welcome_email.text.erb' }
      end
  end

  def daily_poem(user)
    @user = user
    @poem = @user.poem
    mail(
      from: "Tea House<teahouse@teahouse.space>",
      to: @user.email,
      subject: "#{@poem.title}") do |format|
        format.html { render 'daily_poem.html.erb' }
        format.text { render plain: 'daily_poem.text.erb' }
      end
  end
end

num = rand(1..1095)
