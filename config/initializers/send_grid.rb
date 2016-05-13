if ENV['SENDGRID_USER'] && ENV['SENDGRID_PASS']
  ActionMailer::Base.smtp_settings = {
    :user_name => ENV['SENDGRID_USER'],
    :password => ENV['SENDGRID_PASS'],
    :domain => 'ketaminemonitor.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
