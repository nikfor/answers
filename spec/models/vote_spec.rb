require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :voteable }

  it { should validate_inclusion_of(:value).in_array([-1, 1]) }
end
