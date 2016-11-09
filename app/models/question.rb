class Question < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  validates :title, :body, :user_id, presence: true
  after_create :subscription_for_author

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  scope :last_day_questions, -> { where('created_at > ?', 24.hours.ago ) }

  private

  def subscription_for_author
    self.subscriptions.create(user: user)
  end
end

