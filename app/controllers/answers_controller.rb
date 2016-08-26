class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_question, except: [:destroy]
  before_action :find_answer, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answers_path(@question), alert: "Ваш ответ успешно создан."
    else
      render :new
    end
  end

  def index
    @answers = @question.answers
  end

  def destroy
    if own_answer?
      @answer.destroy
      redirect_to questions_path, alert: "Ответ успешно удален"
    else
      redirect_to questions_path, alert: "Вы не можете удалять чужие ответы"
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

  def own_answer?
    find_answer.user_id == current_user.id
  end
end
