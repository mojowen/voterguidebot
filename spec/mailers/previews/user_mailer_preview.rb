# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome
    UserMailer.welcome(User.first)
  end

  def promote
    UserMailer.promote(User.first, User.last)
  end

  def invite_existing
    UserMailer.invite(User.first, Guide.first, 'Jimmy')
  end

  def invite_new
    UserMailer.invite(User.new, Guide.first, 'Jimmy')
  end
end
