require "rails_helper"

describe  "Answers API" do
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }
  let!(:answers_list) { create_list(:answer, 2, question: question) }
  let!(:answer) { answers_list.first }
  let!(:comment) { create(:comment, commentable: answer) }
  let!(:attachment) { create(:attachment, attachable: answer) }


  describe "GET #index" do
    it_behaves_like "API Authenticable"

    context "authorized" do
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }
      it_behaves_like "API success authorizaion"

      it "returns list of answers for question" do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answers object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", {format: :json}.merge(options)
    end
  end

  describe "GET #show" do
    it_behaves_like "API Authenticable"

    context "authorized" do
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }
      it_behaves_like "API success authorizaion"
      it_behaves_like "API Commentable"
      it_behaves_like "API Attachable"

      %w(id body created_at updated_at).each do |attr|
        it "answers object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", {format: :json}.merge(options)
    end
  end

  describe "POST #create" do
    it_behaves_like "API Authenticable"

    context "authorized" do
      context "database changes" do
        it "saves the valid answer in the database" do
          expect{ post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(question.answers, :count).by(1)
        end

        it "does not saves the invalid answer in the database" do
          expect{ post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }.to_not change(Answer, :count)
        end
      end

      context "return json object" do
        before { post "/api/v1/questions/#{question.id}/answers", answer: {body: "abcdtest"}, format: :json, access_token: access_token.token }
        it_behaves_like "API success authorizaion"

        it "answer object contains body" do
          expect(response.body).to be_json_eql("abcdtest".to_json).at_path("body")
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", {format: :json}.merge(options)
    end
  end
end
