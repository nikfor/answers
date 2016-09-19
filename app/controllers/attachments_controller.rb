class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.owner_of?(@attachment.attachable)
      @attachment.destroy
    else
      flash.alert = "Вы не можете удалять чужие файлы"
    end
  end

end
