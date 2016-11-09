class SubscriptionsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_question
  before_action :find_subscription, only: [:destroy]
  before_action :build_subscription, only: [:create]

  respond_to :js

  def create
    authorize! :create, @subscription
    respond_with (@subscription.save)
  end

  def destroy
    authorize! :destroy, @subscription
    respond_with (@subscription.destroy)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_subscription
    @subscription = Subscription.where(question: @question, user: current_user).first
  end

  def build_subscription
    @subscription = Subscription.new(question: @question, user: current_user)
  end

end
