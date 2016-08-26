class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates_associated :user
end
