class ApplicationMailer < ActionMailer::Base
  default from: 'Voter Guide 🤖 <robot@americanvoterguide.org>'
  layout 'mailer'

  add_template_helper(EmailHelper)

end
