class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, except: [:destroy, :update, :best]
  before_action :find_answer, only: [:destroy, :update, :best]

  def show
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash.notice = "Ваш ответ успешно создан."
    end
  end

  def update
    @question = @answer.question
    if current_user.owner_of?(@answer)
      if @answer.update(answer_params)
        flash.notice = "Ответ успешно отредактирован"
      else
        flash.alert = "Где то ошибка, проверьте ответ"
      end
    else
      flash.alert = "Вы не можете редактировать чужой ответ"
    end
  end

  def destroy
    if current_user.owner_of?(@answer)
      @answer.destroy
      flash.notice = "Ответ успешно удален"
    else
      flash.alert = "Вы не можете удалять чужие ответы"
    end
  end

  def best
    if current_user.owner_of?(@answer.question)
      @answer.best!
    else
      flash.alert = "Это чужой вопрос!"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
