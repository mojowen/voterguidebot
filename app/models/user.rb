class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :permissions
  has_many :guides, -> { where(active: true) }, through: :permissions
  has_many :archived_guides, -> { where(active: false) }, through: :permissions, source: :guide
  has_many :exports

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first

      unless user
        user = User.create(first_name: data['first_name'],
                           last_name: data['last_name'],
                           pic: data['image'],
                           email: data['email'],
                           password: Devise.friendly_token[0,20])

        UserMailer.welcome(user).deliver_later
      end
      user
  end

  def guides_included(archived: false)
    archived ? archived_guides : guides.index_scoped
  end

  def name
    [first_name, last_name].join(' ')
  end

  def can_edit?(guide)
    admin? || guides.include?(guide) || archived_guides.include?(guide)
  end

  def promote!(promoter)
    return unless promoter.admin
    update_attributes admin: true
    UserMailer.promote(self, promoter).deliver_later
    true
  end

  def self.invite(email, guide, invitee)
    user = find_or_initialize_by email: email
    user.password = Devise.friendly_token[0,20] if user.new_record?

    user.guides << guide
    return user unless user.valid?
    user.save

    UserMailer.invite(user, guide, invitee).deliver_later
    user
  end
end
