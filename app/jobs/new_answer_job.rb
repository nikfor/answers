class NewAnswerJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscribed_users.each do |user|
      NewAnswerMailer.about_new_answer(user, answer.question).deliver_later
    end
  end
end
