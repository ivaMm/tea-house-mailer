
module Devise
  class MailerPreview < ActionMailer::Preview
    def confirmation_instructions
      Devise::Mailer.confirmation_instructions(User.first, {})
    end

    def reset_password_instructions
      Devise::Mailer.reset_password_instructions(User.first, {})
    end

    def unlock_instructions
      Devise::Mailer.unlock_instructions(User.first, {})
    end

    def email_changed
      Devise::Mailer.email_changed(User.first)
    end
  end
end


# http://localhost:3000/rails/mailers => list of previews
# http://localhost:3000/rails/mailers/devise/mailer/devise_mailer_preview/confirmation_instructions
