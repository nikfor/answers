class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates_associated :question
  validates_associated :user
end
