require 'rails_helper'
require Rails.root.join 'spec/models/concerns/voteable_spec.rb'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many :attachments }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "voteable"

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }

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
end
