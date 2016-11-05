require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  it "call about_new_answer" do
    expect(NewAnswerMailer).to receive(:about_new_answer).with(user, question).and_call_original
    NewAnswerJob.perform_now(answer)
  end
end
