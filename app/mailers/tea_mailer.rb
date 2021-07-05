class TeaMailer < ApplicationMailer
  def welcome_email
    mail(
      from: "Tea House<teahouseteam@teahouse.space>",
      to: params[:user].email, #@user.email,
      subject: 'Hello from TeaHouse!') do |format|
        format.html { render 'welcome_email.html.erb' }
        format.text { render 'welcome_email.text.erb' }
      end
  end

  def daily_poem
    @user = params[:user]
    @poem = @user.poem
    mail(
      from: "Tea House<teahouse@teahouse.space>",
      to: @user.email,
      subject: "Your daily poem: #{@poem.title}") do |format|
        format.html { render 'daily_poem.html.erb' }
        format.text { render 'daily_poem.text.erb' }
      end
  end
end
