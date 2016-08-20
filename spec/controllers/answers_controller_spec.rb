require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe "GET #new" do
    before{ get :new, question_id: question.id }

    it "assigns a new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid arguments" do
      it "saves the new answer belong to question in the database" do
        expect{ post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it "redirects to question view" do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to assigns(:question)
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
end
