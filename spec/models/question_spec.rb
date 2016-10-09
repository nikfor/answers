require 'rails_helper'
require Rails.root.join 'spec/models/concerns/voteable_spec.rb'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "voteable"
end
