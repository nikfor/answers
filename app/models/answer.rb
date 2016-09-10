class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :user_id, :question_id, presence: true

  def self.default_scope
    order(best: :desc, created_at: :desc)
  end

  def best!
    question.answers.update_all(best: false)
    update_attributes(best: true)
  end

end
