class NewAnswerMailer < ApplicationMailer

  def about_new_answer(user, question)
    @question = question

    mail to: user.email, subject: "Новые ответы на подписанные вопросы!"
  end

end
