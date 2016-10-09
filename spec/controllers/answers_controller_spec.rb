require 'rails_helper'
require Rails.root.join 'spec/controllers/concerns/voted_spec.rb'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:other_user) { create(:user) }

  it_behaves_like "voted"

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

  describe "PATCH #update" do
    sign_in_user
    before do
      answer.update(user: @user, question: question)
      patch :update, id: answer, answer: {body: "new answer"}, format: :js
    end

    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end

    it "assigns the question to @question" do
      expect(assigns(:question)).to eq answer.question
    end

    it "changes answer attributes" do
      answer.reload
      expect(answer.body).to eq "new answer"
    end

    it "render update template" do
      expect(response).to render_template :update
    end

    it "doesn't change other user answer attributes" do
      answer.update(user: other_user)
      expect(answer.body).to_not eq "new answer"
    end
  end

  describe "DELETE #destroy" do
    sign_in_user
    let!(:answer2) { create(:answer, user: @user) }

    it "deletes own answer" do
      expect{ delete :destroy, id: answer2, format: :js }.to change(@user.answers, :count).by(-1)
    end

    it "deletes another user answer" do
      answer
      expect{ delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
    end
  end

  describe "POST #best" do

    context "logged user" do
      sign_in_user

      it "changes answer to a own question" do
        answer.update(question: question)
        question.update(user: @user)
        post :best, id: answer, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it "render template best.js" do
        question.update(user: @user)
        post :best, id: answer, format: :js
        expect(response).to render_template :best
      end

      it "not changes answer to another user question" do
        post :best, id: answer, format: :js
        expect(answer.best).to eq false
      end
    end

    it "non logged user not changes answer to best" do
      post :best, id: answer, format: :js
      expect(answer.best).to eq false
    end
  end
end
