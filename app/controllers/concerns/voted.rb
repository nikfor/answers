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
    respond_to do |format|
      if @voteable.user_voted?(current_user)
        if @voteable.cancel_vote(current_user)
          format.json{ render json: {total: @voteable.total, id: @voteable.id} }
        else
          format.json{ render json: @voteable.errors.full_messages, status: :unprocessable_entity }
        end
      else
        format.json { render json: { error: "Вы не можете отменить голос не проголосовав!", id: @voteable.id }, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_voteable
    @voteable = controller_name.classify.constantize.find(params[:id])
  end

  def voting(vote_value)
    respond_to do |format|
      if user_signed_in? && current_user.can_vote?(@voteable)
        if @voteable.user_voted?(current_user)
          changing_vote(vote_value, format)
        else
          creating_vote(vote_value, format)
        end
      else
        format.json { render json: { error: "Вы не можете голосовать за свой вопрос или ответ!", id: @voteable.id }, status: :unprocessable_entity }
      end
    end
  end

  def changing_vote(vote_value, format)
    if @voteable.change_vote!(vote_value, current_user)
      format.json{ render json: { total: @voteable.total, id: @voteable.id } }
    else
      format.json{ render json: @voteable.errors.full_messages, id: @voteable.id, status: :unprocessable_entity }
    end
  end

  def creating_vote(vote_value, format)
    if @voteable.create_vote(vote_value, current_user)
      format.json{ render json: { total: @voteable.total, id: @voteable.id } }
    else
      format.json{ render json: @voteable.errors.full_messages, id: @voteable.id, status: :unprocessable_entity }
    end
  end

end
