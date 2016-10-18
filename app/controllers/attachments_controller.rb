class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  respond_to :js

  def destroy
    if current_user.owner_of?(@attachment.attachable)
      respond_with @attachment.destroy
    end
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
