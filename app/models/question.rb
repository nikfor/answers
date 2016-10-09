class Question < ActiveRecord::Base
  include Attachable
  include Voteable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
end

