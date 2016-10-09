class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes

  validates :email, :password, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def owner_of?(obj)
    id == obj.user_id
  end

  def can_vote?(voteable)
    id != voteable.user_id
  end

  def voted?(voteable)
    !votes.where(voteable: voteable).empty?
  end

end
