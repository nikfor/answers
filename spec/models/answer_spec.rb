require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many :attachments }
  it { should have_many :comments }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "Voteable"

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }
  let!(:answer3) { build(:answer, user: user, question: question) }

  it "make best answer" do
    answer.best!
    expect(answer).to be_best
  end

  it "doesn't make best other answer" do
    answer2.update(best: true)
    answer.best!
    answer2.reload
    expect(answer2).to_not be_best
  end

  it ".new_answers_subscription" do
    expect(NewAnswerJob).to receive(:perform_later)
    answer3.save!
  end
end
