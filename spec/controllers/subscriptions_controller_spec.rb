require "rails_helper"

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }

  describe "POST #create" do
    it "create new subscribe for current_user in the database" do
      expect{ post :create, question_id: question.id, format: :js }.to change(@user.subscriptions, :count).by(1)
    end

    it "doesn't create new subscription if it exist" do
      create(:subscription, question: question, user: @user)
      expect{ post :create, question_id: question.id, format: :js }.to_not change(Subscription, :count)
    end
  end

  describe "DELETE #destroy" do
    it "destroy subscribe for current_user in the database" do
      create(:subscription, question: question, user: @user)
      expect{ delete :destroy, question_id: question.id, format: :js }.to change(@user.subscriptions, :count).by(-1)
    end

    it "doesn't destroy no exist subscription" do
      question.subscriptions.delete_all
      expect{ delete :destroy,  question_id: question.id, format: :js }.to_not change(Subscription, :count)
    end
  end
end
