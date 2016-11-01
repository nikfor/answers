shared_examples_for "API Authenticable" do
  context "unauthorized" do
      it "returns 401 status if is no access token" do
        do_request
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        do_request(access_token: "1234")
        expect(response.status).to eq 401
      end
    end
end

shared_examples_for "API success authorizaion" do
  it "returns 200 code status" do
    expect(response).to be_success
  end
end
