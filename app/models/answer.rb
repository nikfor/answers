class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :user_id, :question_id, presence: true

  default_scope { order(best: :desc, created_at: :desc) }

  def best!
    ActiveRecord::Base.transaction do
      question.answers.each { |q| q.update_attributes!(best: false) }
      update_attributes!(best: true)
    end
  end

end
