class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  validates :email, :password, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def owner_of?(obj)
    id == obj.user_id
  end

  def can_vote?(voteable)
    id != voteable.user_id
  end

  def voted?(voteable)
    !votes.where(voteable: voteable).empty?
  end

  def subscribe(question)
    subscriptions.create(question: question)
  end

  def unsubscribe(question)
    subscriptions.where(question: question).delete_all
  end

  def subscribed?(question)
    !subscriptions.where(question: question).empty?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if email = auth.info[:email]
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
      user
    end
  end
end
