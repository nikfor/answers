class Api::V1::AnswersController < Api::V1::BaseController

  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: [:show]

  authorize_resource

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    respond_with @answer
  end

  def create
    respond_with (@answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id)))
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
