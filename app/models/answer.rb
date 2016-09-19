class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, :user_id, :question_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

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
