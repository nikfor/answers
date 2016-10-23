require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:authorizations) }

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

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456")}

    context "user already has authorization" do
      it "returns the user" do
        user.authorizations.create(provider: "facebook", uid: "123456")
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user hasn't authorization" do
      context "user already exists" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info:{ email: user.email }) }

        it "doesn't create new user" do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context "user doesn't exist" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info:{ email: "new@email.com" }) }

        it "creates new user" do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it "returns new user" do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it "fills user email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it "create authorization for new user" do
          user = User.find_for_oauth(auth)
          expect( user.authorizations).to_not be_empty
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

      end
    end
  end

end
