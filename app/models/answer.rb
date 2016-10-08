class Answer < ActiveRecord::Base
  include Attachable
  include Voteable

  belongs_to :question
  belongs_to :user

  validates :body, :user_id, :question_id, presence: true

  default_scope { order(best: :desc, created_at: :desc) }

  def best!
    ActiveRecord::Base.transaction do
      if best_answer = question.answers.find_by(best: true)
        best_answer.update!(best: false)
      end
      update!(best: true)
    end
  end

end
