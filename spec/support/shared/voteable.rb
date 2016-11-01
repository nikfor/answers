shared_examples_for "Voteable" do
  let(:voteable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:vote_yea) { create(:yea, voteable: voteable) }

  describe "#create_vote" do
    it 'vote yea' do
      voteable.create_vote(1, user)
      expect(voteable.votes.first.value).to eq 1
    end

    it 'vote nay' do
      voteable.create_vote(-1, user)
      expect(voteable.votes.first.value).to eq -1
    end
  end

  it "#change_vote!" do
    vote_yea.update(user: user)
    voteable.change_vote!(-1, user)
    expect(voteable.votes.first.value).to eq -1
  end

  it "#cancel_vote" do
    vote_yea.update(user: user)
    voteable.cancel_vote(user)
    expect(voteable.votes.empty?).to be true
  end

  it "#total" do
    voteable.create_vote(1, user)
    voteable.create_vote(1, user)
    voteable.create_vote(1, user)
    voteable.create_vote(-1, user)
    expect(voteable.total).to eq 2
  end
end
