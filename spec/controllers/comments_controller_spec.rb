require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe "POST #create" do
    context "Question comment" do
      let(:commentable) { question }
      it_behaves_like "Create comment"
    end

    context "Answer comment" do
      let(:commentable) { answer }
      it_behaves_like "Create comment"
    end
  end

  describe "PATCH #update" do
    describe "Question comment" do
      before { comment.update(commentable: question) }
      it_behaves_like "Update comment"
    end

    describe "Answer comment" do
      before { comment.update(commentable: answer) }
      it_behaves_like "Update comment"
    end
  end

  describe "DELETE #destroy" do
    describe "Question comment" do
      before { comment.update(commentable: question) }
      it_behaves_like "Delete comment"
    end
    describe "Answer comment" do
      before { comment.update(commentable: answer) }
      it_behaves_like "Delete comment"
    end
  end
end
