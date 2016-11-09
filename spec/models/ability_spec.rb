require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let(:my_question) { create(:question, user: user) }
    let(:my_answer) { create(:answer, user: user) }
    let(:my_comment) { create(:comment, user: user) }

    let(:other_question) { create(:question, user: other_user) }
    let(:other_answer) { create(:answer, user: other_user) }
    let(:other_comment) { create(:comment, user: other_user) }



    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all }

    context "create" do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context "update" do
      it { should be_able_to :update, my_question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :update, my_answer }
      it { should_not be_able_to :update, other_answer }

      it { should be_able_to :update, my_comment }
      it { should_not be_able_to :update, other_comment }
    end

    context "destroy" do
      it { should be_able_to :destroy, my_question }
      it { should_not be_able_to :destroy, other_question }

      it { should be_able_to :destroy, my_answer }
      it { should_not be_able_to :destroy, other_answer }

      it { should be_able_to :destroy, my_comment }
      it { should_not be_able_to :destroy, other_comment }
    end

    context "attachment" do
      it { should be_able_to :destroy, create(:attachment, attachable: my_question) }
      it { should_not be_able_to :destroy, create(:attachment, attachable: other_question) }

      it { should be_able_to :destroy, create(:attachment, attachable: my_answer) }
      it { should_not be_able_to :destroy, create(:attachment, attachable: other_answer) }
    end

    context "votes question" do
      it { should be_able_to :yea, other_question }
      it { should_not be_able_to :yea, my_question }

      it { should be_able_to :nay, other_question }
      it { should_not be_able_to :nay, my_question }

      it { should_not be_able_to :nullify_vote, other_question }
      context "success nullify" do
        before { create(:yea, user: user, voteable: other_question) }
        it { should be_able_to :nullify_vote, other_question }
      end
    end

    context "votes answer" do
      it { should be_able_to :yea, other_answer }
      it { should_not be_able_to :yea, my_answer }

      it { should be_able_to :nay, other_answer }
      it { should_not be_able_to :nay, my_answer }

      it { should_not be_able_to :nullify_vote, other_answer }
      context "success nullify" do
        before { create(:yea, user: user, voteable: other_answer) }
        it { should be_able_to :nullify_vote, other_answer }
      end
    end

    context "best" do
      before { other_answer.update(question: my_question) }

      it { should be_able_to :best, other_answer }
      it { should_not be_able_to :best, create(:answer, question: other_question) }
    end

    describe "subscription" do
      let(:created_subscription) { create(:subscription, user: user) }
      let(:new_subscription) { build(:subscription, user: user ) }

      context "create subscription" do
        it { should_not be_able_to :create, created_subscription  }
        it { should be_able_to :create, new_subscription }
      end

      context "destroy subscription" do
        it { should be_able_to :destroy, created_subscription }
        it { should_not be_able_to :destroy, new_subscription }
      end
    end
  end

end
