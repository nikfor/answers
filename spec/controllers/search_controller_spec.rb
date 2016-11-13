require 'rails_helper'

RSpec.describe SearchController, type: :controller do
    let!(:question) { create(:question, title: "anything") }

    it "receive search method" do
      expect(ThinkingSphinx).to receive(:search).and_call_original
      get :index, search: { area: "Question", query: "anything"}
    end
end
