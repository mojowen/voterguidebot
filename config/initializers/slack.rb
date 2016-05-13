require 'slack-notifier'

module Slack
  def self.post(message)
    return unless ENV['SLACK_GENERAL'] 
    client.ping message
  end

  def self.post_user(user)
    return unless ENV['SLACK_GENERAL'] 

    client.ping(
      'New User Signup!',
      attachment: {
        fallback: "#{user.first_name} Signed up!",
        color: "#BBDEFB",
        pretext: "New Signup#{ user.guides.empty? ? '' : ' from an Invite' }!",
        thumb_url: user.pic,
        fields: [
            {
              title: "Name",
              value: "#{user.first_name} #{user.last_name}",
              short: false
            },
            {
              title: user.guides.empty? ? '' : 'Invited to Edit',
              value: user.guides.map(&:name).map(&:humanize).join(', '),
              short: false
            }
        ],
      })
  end

  def self.client
    @client ||= Slack::Notifier.new(ENV['SLACK_GENERAL']) 
  end
end
