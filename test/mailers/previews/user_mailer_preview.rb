# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def user_mailer
    UserMailer.invite_email(User.first, Attendee.first)
  end
end
