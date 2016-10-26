module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_voteable, only: [ :yea, :nay, :nullify_vote, :voting, :changing_vote, :create_vote]
  end

  def yea
    authorize! :yea, @voteable, message: { text: "Вы не можете голосовать за свой вопрос или ответ!", id: @voteable.id }
    voting(1)
  end

  def nay
    authorize! :nay, @voteable, message: { text: "Вы не можете голосовать за свой вопрос или ответ!", id: @voteable.id }
    voting(-1)
  end

  def nullify_vote
    authorize! :nullify_vote, @voteable, message: { text: "Вы не можете отменить голос не проголосовав!", id: @voteable.id }
    @voteable.cancel_vote(current_user)
    render json: {total: @voteable.total, id: @voteable.id}
  end

  private

  def find_voteable
    @voteable = controller_name.classify.constantize.find(params[:id])
  end

  def voting(vote_value)
    if current_user.voted?(@voteable)
      changing_vote(vote_value)
    else
      creating_vote(vote_value)
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
