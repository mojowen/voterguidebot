class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: "#{@user.first_name} <#{@user.email}>",
         subject: "Let's Build Some Voter Guides!!")
  end

  def promote(user, promoter)
    @user = user
    @promoter = promoter.first_name
    mail(
      to: "#{@user.first_name} <#{@user.email}>",
      subject: "You're an W̶i̶z̶a̶r̶d̶ Admin H̶a̶r̶r̶y̶ #{user.first_name}",
      cc: User.where(admin: true).map{ |ur| "#{ur.first_name} <#{ur.email}>" }.join(',')
    )
  end

  def invite(user, guide, invitee)
    @user = user
    @guide = guide
    @invitee = invitee
    mail(
      to: "#{@user.first_name || @user.email} <#{@user.email}>",
      subject: "Invitation to Edit #{@guide.name.capitalize}"
    )
  end
end
