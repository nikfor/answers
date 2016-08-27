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
      redirect_to question_path(@question), notice: "Ваш ответ успешно создан."
    else
      render :new
    end
  end

  def index
    @answers = @question.answers
  end

  def destroy
    if current_user.owner_of?(@answer)
      @answer.destroy
      flash.notice = "Ответ успешно удален"
    else
      flash.alert = "Вы не можете удалять чужие ответы"
    end
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_user)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

end
