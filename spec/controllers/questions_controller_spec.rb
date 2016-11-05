require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { FactoryGirl.create(:question, title: "Сколько будет 2+2 ?") }

  it_behaves_like "Voted"

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

  describe "POST #create" do
    sign_in_user
    context "with valid arguments" do
      it "saves the new question in the database" do
        expect{ post :create, question: attributes_for(:question), format: :js }.to change(@user.questions, :count).by(1)
      end

      it "redirects to show view" do
        post :create, question: attributes_for(:question), format: :js
        expect(response).to render_template :create
      end
    end

    context "with invalid arguments" do
      it "doesnt save the new question in the database" do
        question
        expect{ post :create, question: attributes_for(:invalid_question), format: :js }.to_not change(Question, :count)
      end

      it "re-render new page" do
        post :create, question: attributes_for(:invalid_question), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
    sign_in_user
    context "with valid arguments" do
      before do
        question.update(user: @user)
        patch :update, id: question, question:{ title: "new title", body: "new body" }, format: :js
      end

      it "assigns the requested question to @question" do
        expect(assigns(:question)).to eq question
      end

      it "changes question attributes" do
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it "render update.js template" do
        expect(response).to render_template :update
      end
    end

    context "with invalid arguments" do
      before do
        question.update(user: @user)
        patch :update, id: question, question:{ title: "new title", body: nil }, format: :js
      end
      it "does not change question attributes" do
        question.reload
        expect(question.title).to eq "Сколько будет 2+2 ?"
        expect(question.body).to eq "Никак не могу понять, сколько будет 2+2, помогите с решением проблемы!"
      end

      it "render update.js template" do
        expect(response).to render_template :update
      end
    end

    it "doesn't change other user question" do
        patch :update, id: question, question:{ title: "new title", body: "new body" }, format: :js
        expect(question.title).to_not eq "new title"
        expect(question.body).to_not eq "new body"
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
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #subscribe" do
    sign_in_user

    it "create new subscribe for current_user in the database" do
      expect{ post :subscribe, id: question, format: :js }.to change(@user.subscriptions, :count).by(1)
    end

    it "doesn't create new subscription if it exist" do
      create(:subscription, question: question, user: @user)
      expect{ post :subscribe, id: question, format: :js }.to_not change(Subscription, :count)
    end
  end

  describe "DELETE #unsubscribe" do
    sign_in_user

    it "destroy subscribe for current_user in the database" do
      create(:subscription, question: question, user: @user)
      expect{ delete :unsubscribe, id: question, format: :js }.to change(@user.subscriptions, :count).by(-1)
    end

    it "doesn't destroy no exist subscription" do
      question.subscriptions.delete_all
      expect{ delete :unsubscribe, id: question, format: :js }.to_not change(Subscription, :count)
    end
  end
end
