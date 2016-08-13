class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :permissions
  has_many :guides, through: :permissions

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first

      unless user
        user = User.create(first_name: data['first_name'],
                           last_name: data['last_name'],
                           pic: data['image'],
                           email: data['email'],
                           password: Devise.friendly_token[0,20])

        UserMailer.welcome(user).deliver_now
      end
      user
  end

  def name
    [first_name, last_name].join(' ')
  end

  def can_edit?(guide)
    admin? || guides.include?(guide)
  end

  def promote!(promoter)
    return unless promoter.admin
    update_attributes admin: true
    UserMailer.promote(self, promoter)
    true
  end

  def self.invite(email, guide, invitee)
    user = find_or_initialize_by email: email
    user.password = Devise.friendly_token[0,20] if user.new_record?

    user.guides << guide
    user.save!
    UserMailer.invite(user, guide, invitee).deliver_now

    user
  end
end
