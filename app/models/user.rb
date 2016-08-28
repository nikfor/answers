class User < ActiveRecord::Base
  has_many :questions
  has_many :answers

  validates :email, :password, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def owner_of?(obj)
    id == obj.user_id
  end
end
