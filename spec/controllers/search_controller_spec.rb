require 'rails_helper'

RSpec.describe SearchController, type: :controller do
    let!(:question) { create(:question, title: "anything") }

    it "receive search method in Question" do
      expect(Question).to receive(:search).with("anything").and_call_original
      get :index, search: { area: "Question", query: "anything"}
    end

    it "receive search method in Answer" do
      expect(Answer).to receive(:search).with("anything").and_call_original
      get :index, search: { area: "Answer", query: "anything"}
    end

    it "receive search method in Comment" do
      expect(Comment).to receive(:search).with("anything").and_call_original
      get :index, search: { area: "Comment", query: "anything"}
    end

    it "receive search method in User" do
      expect(User).to receive(:search).with("user\\@user.ru").and_call_original
      get :index, search: { area: "User", query: "user@user.ru"}
    end

    it "receive search method in All" do
      expect(ThinkingSphinx).to receive(:search).with("anything").and_call_original
      get :index, search: { area: "ThinkingSphinx", query: "anything"}
    end

    it "receive search method if passed invalid search area" do
      expect(ThinkingSphinx).to receive(:search).with("12345").and_call_original
      get :index, search: { area: "qwerty", query: "12345"}
    end
end
