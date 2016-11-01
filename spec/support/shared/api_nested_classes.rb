shared_examples_for "API Commentable" do
  it "included in answer object" do
    expect(response.body).to have_json_size(1).at_path("comments")
  end

  %w(id body created_at updated_at).each do |attr|
    it "comment object contains #{attr}" do
      expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
    end
  end
end

shared_examples_for "API Attachable" do
  it "included in answer object" do
    expect(response.body).to have_json_size(1).at_path("attachments")
  end

  it "attachment object contains file url" do
    expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/file/url")
  end
end



