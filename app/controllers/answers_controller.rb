class AnswersController < ApplicationController

  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: [:show, :create]
  before_action :find_answer, only: [:destroy, :update, :best]

  respond_to :js

  def show
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    if current_user.owner_of?(@answer)
      @answer.update(answer_params)
      respond_with @answer
    else
      flash.alert = "Вы не можете редактировать чужой ответ"
    end
  end

  def destroy
    if current_user.owner_of?(@answer)
      respond_with(@answer.destroy)
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
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
