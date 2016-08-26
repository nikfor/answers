class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to questions_path, alert: "Ваш вопрос успешно создан."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if own_question?
      @question.destroy
      redirect_to questions_path, alert: "Вопрос успешно удален"
    else
      redirect_to questions_path, alert: "Вы не можете удалять чужие вопросы"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def own_question?
    find_question.user_id == current_user.id
  end

end
