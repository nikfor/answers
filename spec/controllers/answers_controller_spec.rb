require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe "GET #index" do
    let(:answers) { create_list(:answer, 2, question: question) }

    before{ get :index, question_id: question.id }

    it "populates an array of all questions" do
      question
      expect(assigns(:answers)).to match_array(answers)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    sign_in_user
    before{ get :new, question_id: question.id }

    it "assigns a new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    sign_in_user
    context "with valid arguments" do
      it "saves the new answer belong to question in the database" do
        expect{ post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it "redirects to question view" do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid arguments" do
      it "doesnt save the new answer in the database" do
        answer
        expect{ post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it "re-render new page" do
        question
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    let(:answer2) { create(:answer, user: @user) }
    sign_in_user

    context "by owner answer" do
      it "deletes answer" do
        answer2
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
