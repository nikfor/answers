class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_comment, only: [:destroy, :update]
  before_action :find_commentable, only: [:create]

  respond_to :js

  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  def update
    @comment.update(comment_params)
    respond_with @comment
  end

  def destroy
    respond_with @comment.destroy
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
