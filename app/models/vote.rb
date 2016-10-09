class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :value, :user_id, presence: true
  validates :value, inclusion: { in: [-1, 1],
    message:"Vote может принимать только два значения: -1 и 1"}
end
