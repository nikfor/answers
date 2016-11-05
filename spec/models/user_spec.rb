require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:users) { create_list(:user, 2) }
  let(:user) { users.first }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question) }

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
    let!(:vote_yea) { create(:yea, voteable: question) }

    it "user voted" do
      vote_yea.update(user: user)
      expect(user).to be_voted(question)
    end

    it "user doesn't vote" do
      expect(user).to_not be_voted(question)
    end
  end

  describe "#subscribe" do
    it { expect{ user.subscribe(another_question) }.to change(user.subscriptions, :count).by(1) }
    it { expect{ user.subscribe(another_question) }.to change(another_question.subscriptions, :count).by(1) }
  end

  describe "#unsubscribe" do
    before { create(:subscription, user: user, question: another_question) }
    it { expect{ user.unsubscribe(another_question) }.to change(user.subscriptions, :count).by(-1) }
    it { expect{ user.unsubscribe(another_question) }.to change(another_question.subscriptions, :count).by(-1) }
  end

  describe "#subscribed?" do
    it { expect(user).to be_subscribed(question) }
    it { expect(user).to_not be_subscribed(another_question) }
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
