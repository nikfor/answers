module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_voteable, only: [ :yea, :nay, :nullify_vote, :voting, :changing_vote, :create_vote]
  end

  def yea
    voting(1)
  end

  def nay
    voting(-1)
  end

  def nullify_vote
    if current_user.voted?(@voteable)
      @voteable.cancel_vote(current_user)
      render json: {total: @voteable.total, id: @voteable.id}
    else
      render json: { error: "Вы не можете отменить голос не проголосовав!", id: @voteable.id }, status: :unprocessable_entity
    end
  end

  private

  def find_voteable
    @voteable = controller_name.classify.constantize.find(params[:id])
  end

  def voting(vote_value)
    if user_signed_in? && current_user.can_vote?(@voteable)
      if current_user.voted?(@voteable)
        changing_vote(vote_value)
      else
        creating_vote(vote_value)
      end
    else
      render json: { error: "Вы не можете голосовать за свой вопрос или ответ!", id: @voteable.id }, status: :unprocessable_entity
    end
  end

  def changing_vote(vote_value)
    if @voteable.change_vote!(vote_value, current_user)
      render json: { total: @voteable.total, id: @voteable.id }
    else
      render json: @voteable.errors.full_messages, id: @voteable.id, status: :unprocessable_entity
    end
  end

  def creating_vote(vote_value)
    if @voteable.create_vote(vote_value, current_user)
      render json: { total: @voteable.total, id: @voteable.id }
    else
      render json: @voteable.errors.full_messages, id: @voteable.id, status: :unprocessable_entity
    end
  end

end
