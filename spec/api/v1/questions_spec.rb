require "rails_helper"

describe  "Questions API" do
  let(:access_token) { create(:access_token) }
  let!(:questions) { create_list(:question, 2) }
  let!(:question) { questions.first }
  let!(:answer) { create(:answer, question: question) }
  let!(:comment) { create(:comment, commentable: question) }
  let!(:attachment) { create(:attachment, attachable: question) }


  describe "GET #index" do

    context "unauthorized" do
      it "returns 401 status if is no access token" do
        get "/api/v1/questions", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get "/api/v1/questions", format: :json, access_token: "12345"
        expect(response.status).to eq 401
      end
    end

    context "authorized" do

      before { get "/api/v1/questions", format: :json, access_token: access_token.token }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      it "returns list of questions" do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "questions object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context "answers" do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "questions object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe "GET #show"  do
    context "unauthorized" do
      it "returns 401 status if is no access token" do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: "12345"
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      before { get "/api/v1/questions/#{question.id}", access_token: access_token.token, format: :json }

      it "returns 200 code status" do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context "answers" do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "attachment object contains file url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/file/url")
        end
      end

      context "comments" do
        it "included in question object" do
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
        post "/api/v1/questions", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        post "/api/v1/questions", format: :json, access_token: "12345"
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      context "database changes" do
        it "saves the valid_question in the database" do
          expect{ post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: access_token.token }.to change(Question, :count).by(1)
        end

        it "does not saves the invalid_question in the database" do
          expect{ post "/api/v1/questions", question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }.to_not change(Question, :count)
        end
      end

      context "return json object" do
        before { post "/api/v1/questions", question: {title: question.title, body: question.body}, format: :json, access_token: access_token.token }

        it "returns 200 code status" do
          expect(response).to be_success
        end

        %w(title body).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end
    end
  end
end
