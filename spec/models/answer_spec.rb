require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }

  it "set best field of answer to true" do
    answer.best!
    expect(answer.best).to eq true
    expect(answer2.best).to eq false
  end
end
