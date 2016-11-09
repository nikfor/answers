class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.last_day_questions

    mail to: user.email, subject: "Список новых вопросов за прошлый день."
  end
end
