module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end

  def user_voted?(user)
    !votes.where(user: user).empty?
  end

  def create_vote(val, user)
    votes.create(user: user, value: val)
  end

  def change_vote!(val, user)
    votes.where(user: user).update_all(value: val)
  end

  def cancel_vote(user)
    votes.where(user: user).delete_all
  end

  def total
    votes.sum(:value)
  end

end
