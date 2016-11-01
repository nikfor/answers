shared_examples_for "Create comment" do
  let(:commentable_s) { commentable.class.name.underscore }
  let(:commentable_id) { commentable_s + "_id" }

  context "with valid arguments" do
    it "saves the new comment in the database" do
      expect{ post :create, comment: attributes_for(:comment), commentable: commentable_s, commentable_id => commentable.id, format: :js }.
        to change(commentable.comments, :count).by(1)
    end

    it "saves the new comment belong to user in the database" do
      expect{ post :create, comment: attributes_for(:comment), commentable: commentable_s, commentable_id => commentable.id, format: :js }.
        to change(@user.comments, :count).by(1)
    end

    it "render create.js template" do
      post :create, comment: attributes_for(:comment), commentable: commentable_s, commentable_id => commentable.id, format: :js
      expect(response).to render_template :create
    end
  end

  context "with invalid arguments" do
    it "doesnt save the new comment in the database" do
      expect{ post :create, comment: { body: ""}, commentable: commentable_s, commentable_id => commentable.id, format: :js }.to_not change(Comment, :count)
    end

    it "render create.js template" do
      post :create, comment: { body: ""}, commentable: commentable_s, commentable_id => commentable.id, format: :js
      expect(response).to render_template :create
    end
  end
end

shared_examples_for "Update comment" do
  let(:mike) { create(:user) }
  let(:comment) { create(:comment, user: @user) }

  context "with valid arguments" do
    before { patch :update, id: comment.id, comment: { body: "new comment" }, format: :js }

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
      patch :update, id: comment.id, comment: { body: "" }, format: :js
      comment.reload
      expect(comment.body).to eq "Ничего не понятно, уточните пожалуйста детали!"
    end

    it "try to update other user comment" do
      comment.update(user: mike)
      patch :update, id: comment.id, comment: { body: "new comment" }, format: :js
      comment.reload
      expect(comment.body).to eq "Ничего не понятно, уточните пожалуйста детали!"
    end
  end
end

shared_examples_for "Delete comment" do
  let(:mike) { create(:user) }
  let!(:comment) { create(:comment, user: @user) }

  it "delete own comment and user comments count decrease by 1" do
    expect{ delete :destroy, id: comment.id, format: :js }.to change(@user.comments, :count).by(-1)
  end

  it "delete another user comment" do
    comment.update(user: mike)
    expect{ delete :destroy, id: comment.id, format: :js }.to_not change(Comment, :count)
  end
end
