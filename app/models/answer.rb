class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true
  validates_associated :question
end
