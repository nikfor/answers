class Attachment < ActiveRecord::Base
  delegate :identifier, to: :file

  belongs_to :question

  mount_uploader :file, FileUploader
end
