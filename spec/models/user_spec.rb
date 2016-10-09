require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:vote_yea) { create(:yea, voteable: question) }

  describe "#owner_of?" do
    let(:another_user) { create(:user) }

    it "returns true if user is owner of object" do
      expect(user).to be_owner_of(question)
    end

    it "returns false if user doesn't owner of object" do
      expect(another_user).to_not be_owner_of(question)
    end
  end

  describe "#voted?" do
    it "user voted" do
      vote_yea.update(user: user)
      expect(user).to be_voted(question)
    end

    it "user doesn't vote" do
      expect(user).to_not be_voted(question)
    end
  end

end
