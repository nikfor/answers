require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:answer) { create(:answer) }
  let(:my_file) { create(:attachment, attachable: answer) }

  describe "DELETE #destroy" do
    sign_in_user

    it "assigns attachment to @attachment" do
      answer.update(user: @user)
      delete :destroy, id: my_file, format: :js

      expect(assigns(:attachment)).to eq my_file
    end

    it "deletes own attachment" do
      answer.update(user: @user)

      expect{ delete :destroy, id: my_file, format: :js }.to change(my_file.attachable.attachments, :count).by(-1)
    end

    it "dont deletes another user answer files" do
      expect{ delete :destroy, id: my_file, format: :js }.to_not change(my_file.attachable.attachments, :count)
    end
  end
end
