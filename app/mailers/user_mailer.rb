class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Let's Build Some Voter Guides!!")
  end

  def invite(user, guide, invitee)
    @user = user
    @guide = guide
    @invitee = invitee
    mail(to: @user.email, subject: "Invitation to Edit #{@guide.name.capitalize}")
  end
end
