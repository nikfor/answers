class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_comment, only: [:destroy, :update]
  before_action :find_commentable, only: [:create]

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  def update
    if current_user.owner_of?(@comment)
      @comment.update(comment_params)
      respond_with @comment
    else
      flash.alert = "Вы не можете редактировать чужой комментарий"
    end
  end

  def destroy
    if current_user.owner_of?(@comment)
      respond_with @comment.destroy
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
