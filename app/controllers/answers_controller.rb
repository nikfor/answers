class AnswersController < ApplicationController

  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: [:show, :create]
  before_action :find_answer, only: [:destroy, :update, :best]

  respond_to :js

  authorize_resource

  def show
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    @answer.best!
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
