class TeaMailerPreview < ActionMailer::Preview
  def welcome_email
    TeaMailer.with(user: User.first).welcome_email
  end

  def daily_poem
    TeaMailer.with(user: User.first).daily_poem
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/tea_mailer
