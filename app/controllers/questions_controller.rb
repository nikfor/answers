class QuestionsController < ApplicationController

  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = @answers.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: "Ваш вопрос успешно создан."
    else
      render :new
    end
  end

  def update
    if current_user.owner_of?(@question)
      if @question.update(question_params)
        flash.notice = "Вопрос успешно отредактирован."
      else
        flash.alert = "Возникла ошибка проверьте данные!"
      end
    else
      flash.alert = "Вы не можете редактировать чужой вопрос!"
    end
  end

  def destroy
    if current_user.owner_of?(@question)
      @question.destroy
      flash.notice = "Вопрос успешно удален"
    else
      flash.alert = "Вы не можете удалять чужие вопросы"
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
