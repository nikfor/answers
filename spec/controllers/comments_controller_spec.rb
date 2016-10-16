require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:mike) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:comment) { create(:comment, user: @user) }

  sign_in_user

  describe "POST #create" do
    context "Question comment" do
      context "with valid arguments" do
        it "saves the new comment belong to question in the database" do
          expect{ post :create, comment: attributes_for(:comment), commentable: "question", question_id: question.id, format: :js }.
            to change(question.comments, :count).by(1)
        end

        it "saves the new comment belong to user in the database" do
          expect{ post :create, comment: attributes_for(:comment), commentable: "question", question_id: question.id, format: :js }.
            to change(@user.comments, :count).by(1)
        end

        it "render create.js template" do
          post :create, comment: attributes_for(:comment), commentable: "question", question_id: question.id, format: :js
          expect(response).to render_template :create
        end
      end

      context "with invalid arguments" do
        it "doesnt save the new comment in the database" do
          expect{ post :create, comment: { body: ""}, commentable: "question", question_id: question.id, format: :js }.to_not change(Comment, :count)
        end

        it "render create.js template" do
          post :create, comment: { body: ""}, commentable: "question", question_id: question.id, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context "Answer comment" do
      context "with valid arguments" do
        it "saves the new comment belong to answer in the database" do
          expect{ post :create, comment: attributes_for(:comment), commentable: "answer", answer_id: answer.id, format: :js }.
            to change(answer.comments, :count).by(1)
        end

        it "saves the new comment belong to user in the database" do
          expect{ post :create, comment: attributes_for(:comment), commentable: "answer", answer_id: answer.id, format: :js }.
            to change(@user.comments, :count).by(1)
        end

        it "render create.js template" do
          post :create, comment: attributes_for(:comment), commentable: "answer", answer_id: answer.id, format: :js
          expect(response).to render_template :create
        end
      end

      context "with invalid arguments" do
        it "doesnt save the new comment in the database" do
          expect{ post :create, comment: { body: ""}, commentable: "answer", answer_id: answer.id, format: :js }.to_not change(Comment, :count)
        end

        it "render create.js template" do
          post :create, comment: { body: ""}, commentable: "answer", answer_id: answer.id, format: :js
          expect(response).to render_template :create
        end
      end
    end
  end

  describe "PATCH #update" do
    describe "Question comment" do
      before { comment.update(commentable: question) }

      context "with valid arguments" do
        before { patch :update, id: comment.id, comment: {body: "new comment"}, format: :js }

        it "assigns the requested comment to @comment" do
          expect(assigns(:comment)).to eq comment
        end

        it "changes comment attributes" do
          comment.reload
          expect(comment.body).to eq "new comment"
        end

        it "render update template" do
          expect(response).to render_template :update
        end
      end

      context "with invalid arguments" do
        it "try to update with empty body" do
          patch :update, id: comment.id, comment: {body: ""}, format: :js
          comment.reload
          expect(comment.body).to eq "Ничего не понятно, уточните пожалуйста детали!"
        end

        it "try to update other user comment" do
          comment.update(user: mike)
          patch :update, id: comment.id, comment: {body: "new comment"}, format: :js
          comment.reload
          expect(comment.body).to eq "Ничего не понятно, уточните пожалуйста детали!"
        end
      end
    end

    describe "Answer comment" do
      before { comment.update(commentable: answer) }

      context "with valid arguments" do
        before { patch :update, id: comment.id, comment: {body: "new comment"}, format: :js }

        it "assigns the requested comment to @comment" do
          expect(assigns(:comment)).to eq comment
        end

        it "changes comment attributes" do
          comment.reload
          expect(comment.body).to eq "new comment"
        end

        it "render update template" do
          expect(response).to render_template :update
        end
      end

      context "with invalid arguments" do
        it "try to update with empty body" do
          patch :update, id: comment.id, comment: {body: ""}, format: :js
          comment.reload
          expect(comment.body).to eq "Ничего не понятно, уточните пожалуйста детали!"
        end

        it "try to update other user comment" do
          comment.update(user: mike)
          patch :update, id: comment.id, comment: {body: "new comment"}, format: :js
          comment.reload
          expect(comment.body).to eq "Ничего не понятно, уточните пожалуйста детали!"
        end
      end
    end
  end

  describe "DELETE #destroy" do
    describe "Question comment" do
      it "delete own comment" do
        comment
        expect{ delete :destroy, id: comment.id, format: :js }.to change(@user.comments, :count).by(-1)
      end

      it "delete another user comment" do
        comment.update(user: mike)
        comment.reload
        expect{ delete :destroy, id: comment.id, format: :js }.to_not change(Comment, :count)
      end
    end
    describe "Answer comment" do
    end
  end
end
