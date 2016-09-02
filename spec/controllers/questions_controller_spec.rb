  require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, title: "Сколько будет 2+2 ?") }

  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }

    before{ get :index }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before{ get :show, id: question }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "assigns new answer for question" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    sign_in_user
    before{ get :new }

    it "assigns a new question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    sign_in_user
    before{ get :edit, id: question }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "render edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    sign_in_user
    context "with valid arguments" do
      it "saves the new question in the database" do
        expect{ post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end

      it "redirects to show view" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid arguments" do
      it "doesnt save the new question in the database" do
        question
        expect{ post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it "re-render new page" do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    sign_in_user
    context "with valid arguments" do
      before{ patch :update, id: question, question: {title: "new title", body: "new body"} }

      it "assigns the requested question to @question" do
        expect(assigns(:question)).to eq question
      end

      it "changes question attributes" do
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it "redirects to show view" do
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid arguments" do
      before { patch :update, id: question, question: {title: "new title", body: nil} }
      it "does not change question attributes" do
        question.reload
        expect(question.title).to eq "Сколько будет 2+2 ?"
        expect(question.body).to eq "Никак не могу понять, сколько будет 2+2, помогите с решением проблемы!"
      end

      it "re-render edit page" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    let(:question2) { create(:question, user: @user) }
    sign_in_user

    context "own question" do
      it "deletes question" do
        question2
        expect{ delete :destroy, id: question2 }.to change(@user.questions, :count).by(-1)
      end

      it "redirects to index view " do
        delete :destroy, id: question2
        expect(response).to redirect_to questions_path
      end
    end

    context "another user question" do
      it "deletes question" do
        question
        expect{ delete :destroy, id: question }.to_not change(Question, :count)
      end

      it "redirects to sign_in view " do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end

end
