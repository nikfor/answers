class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_comment, only: [:destroy, :update]
  before_action :find_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash.notice = "Комментарий успешно создан."
    end
  end

  def update
    if current_user.owner_of?(@comment)
      if @comment.update(comment_params)
        flash.notice = "Комментарий успешно отредактирован"
      else
        flash.alert = "Где то ошибка, проверьте комментарий"
      end
    else
      flash.alert = "Вы не можете редактировать чужой комментарий"
    end
  end

  def destroy
    if current_user.owner_of?(@comment)
      @comment.destroy
      flash.notice = "Комментарий успешно удален"
    else
      flash.alert = "Вы не можете удалять чужие комментарии"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = commentable_name.classify.constantize.find(params["#{commentable_name}_id".to_sym])
  end

  def commentable_name
    params[:commentable]
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
