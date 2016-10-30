require "rails_helper"

describe  "Answers API" do
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }
  let!(:answers_list) { create_list(:answer, 2, question: question) }
  let!(:answer) { answers_list.first }
  let!(:comment) { create(:comment, commentable: answer) }
  let!(:attachment) { create(:attachment, attachable: answer) }


  describe "GET #index" do
    context "unauthorized" do
      it "returns 401 status if is no access token" do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: "12345"
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      it "returns list of answers for question" do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answers object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end
  end

  describe "GET #show" do
    context "unauthorized" do
      it "returns 401 status if is no access token" do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: "12345"
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answers object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context "attachments" do
        it "included in answer object" do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "attachment object contains file url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/file/url")
        end
      end

      context "comments" do
        it "included in answer object" do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe "POST #create" do
    context "unauthorized" do
      it "returns 401 status if is no access token" do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: "12345"
        expect(response.status).to eq 401
      end
    end

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

        it "returns 200 code status" do
          expect(response).to be_success
        end

        it "answer object contains body" do
          expect(response.body).to be_json_eql("abcdtest".to_json).at_path("body")
        end
      end
    end
  end
end
