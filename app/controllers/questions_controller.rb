class QuestionsController < ApplicationController

  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]
  before_action :build_answer, only: [:show]

  respond_to :html
  respond_to :js, only: [:create, :update]

  authorize_resource

  def index
    respond_with (@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def create
    respond_with (@question = Question.create(question_params.merge(user_id: current_user.id)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

end
