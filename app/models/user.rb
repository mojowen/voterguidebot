class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :permissions
  has_many :guides, through: :permissions

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first

      user || User.create(first_name: data['first_name'],
                          last_name: data['last_name'],
                          pic: data['image'],
                          email: data['email'],
                          password: Devise.friendly_token[0,20])
  end

  def can_edit?(guide)
    admin? || guides.include?(guide)
  end

  def promote
  end

  def self.invite(email, guide)
    user = find_or_initialize_by email: email

    if user.new_record?
      user.password = Devise.friendly_token[0,20]
    end

    user.guides << guide
    user.save!
    user
  end

end
