require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe "POST #create" do
    sign_in_user
    context "with valid arguments" do
      it "saves the new answer belong to question in the database" do
        expect{ post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it "saves the new answer belong to user in the database" do
        expect{ post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(@user.answers, :count).by(1)
      end

      it "render create.js template" do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context "with invalid arguments" do
      it "doesnt save the new answer in the database" do
        answer
        expect{ post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it "render create.js template" do
        question
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user
    let!(:answer2) { create(:answer, user: @user) }

    context "by owner answer" do
      it "deletes answer" do
        expect{ delete :destroy, id: answer2 }.to change(@user.answers, :count).by(-1)
      end

      it "redirects to question show view " do
        delete :destroy, id: answer2
        expect(response).to redirect_to answer2.question
      end
    end

    context "another user answer" do
      it "deletes answer" do
        answer
        expect{ delete :destroy, id: answer }.to_not change(Answer, :count)
      end

      it "redirects to question show view " do
        delete :destroy, id: answer
        expect(response).to redirect_to answer.question
      end
    end
  end
end
