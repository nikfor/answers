require "rails_helper"

describe "Profiles API" do

  describe "GET /me" do
    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get "/api/v1/profiles/me", format: :json, access_token: access_token.token }
      it_behaves_like "API success authorizaion"

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesnt contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/profiles/me", {format: :json}.merge(options)
    end
  end

  describe "GET #index" do
    let!(:users) { create_list(:user, 5) }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get "/api/v1/profiles", format: :json, access_token: access_token.token }
      it_behaves_like "API success authorizaion"

      it "contains true count of users" do
        expect(response.body).to have_json_size(users.count)
      end

      it "contains list of all users" do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it "doesnt contains me" do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(users.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesnt contain #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
        end
      end
    end
  end

  def do_request(options = {})
    get "/api/v1/profiles", {format: :json}.merge(options)
  end
end
