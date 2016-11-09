require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "Voteable"

  describe "#last_day_questions" do
    let!(:question) { create(:question) }
    let!(:question2) { create(:question, created_at: 2.days.ago) }

    it "returns the questions created later than 24 hours ago" do
      expect(Question.last_day_questions).to include(question)
    end

    it "not returns the questions created no later than 24 hours ago" do
      expect(Question.last_day_questions).to_not include(question2)
    end
  end

  describe "add subscription when create question" do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }

    it "for author" do
      expect{ create(:question, user: user) }.to change(user.subscriptions, :count).by(1)
    end

    it "for another user" do
      expect{ create(:question, user: user) }.to_not change(another_user.subscriptions, :count)
    end
  end
end
