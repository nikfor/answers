class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id

    can :destroy, Attachment do |attachment|
      user.owner_of?(attachment.attachable)
    end

    can [:yea, :nay], [Question, Answer] do |voteable|
      user.can_vote?(voteable)
    end

    can :nullify_vote, [Question, Answer] do |voteable|
      user.voted?(voteable)
    end

    can :best, Answer, question: { user_id: user.id }

    can :me, User, id: user.id
    can :index, User

    can :subscribe, Question do |question|
      !user.subscribed?(question)
    end

    can :unsubscribe, Question do |question|
      user.subscribed?(question)
    end
  end
end
