shared_examples_for "Voted" do
  let(:user) { create(:user) }
  let(:voteable) { create(controller.controller_name.underscore.chop.to_sym, user: user) }
  let(:vote_nay) { create(:nay, voteable: voteable) }

  describe "POST #yea" do
    sign_in_user

    context "i can vote for other users voteables" do
      it "create new vote if doesnt exists" do
        expect{ post :yea, { id: voteable, format: :json } }.to change(voteable.votes, :count).by(1)
      end

      context "changes vote if it exists" do
        before do
          vote_nay.update(user: @user)
          voteable.reload
        end

        it "changes value" do
          post :yea, { id: voteable, format: :json }
          expect(voteable.votes.first.value).to eq 1
        end

        it "doesnt create new vote" do
          expect { post :yea, { id: voteable, format: :json } }.to_not change(Vote, :count)
        end
      end
    end

    context "i can't vote for my voteables(answers or questions)" do
      before do
        voteable.update(user: @user)
        voteable.reload
      end

      it "doesn't create new vote" do
        expect { post :yea, { id: voteable, format: :json } }.to_not change(Vote, :count)
      end

      it "show error message" do
        post :yea, { id: voteable, format: :json }
        expect(JSON.parse(response.body)['errors']).to eq "Вы не можете голосовать за свой вопрос или ответ!"
      end
    end
  end

  describe "POST #nay" do
    sign_in_user

    context "i can vote other users voteables" do
      it "create new vote if doesnt exists" do
        expect{ post :nay, { id: voteable, format: :json } }.to change(voteable.votes, :count).by(1)
      end

      context "changes vote if it exists" do
        before do
          vote_nay.update(user: @user)
          voteable.reload
        end

        it "changes value" do
          post :nay, { id: voteable, format: :json }
          expect(voteable.votes.first.value).to eq -1
        end

        it "doesnt create new vote" do
          expect { post :nay, { id: voteable, format: :json } }.to_not change(Vote, :count)
        end
      end
    end

    context "i can't vote for my voteables(answers or questions)" do
      before do
        voteable.update(user: @user)
        voteable.reload
      end

      it "doesn't create new vote" do
        expect { post :nay, { id: voteable, format: :json } }.to_not change(Vote, :count)
      end

      it "show error message" do
        post :nay, { id: voteable, format: :json }
        expect(JSON.parse(response.body)['errors']).to eq "Вы не можете голосовать за свой вопрос или ответ!"
      end
    end
  end

  describe "DELETE #nullify_vote" do
    sign_in_user

    it "nullify exist vote" do
      vote_nay.update(user: @user)
      voteable.reload
      expect{ delete :nullify_vote, { id: voteable, format: :json } }.to change(voteable.votes, :count).by(-1)
    end

    it "nullify doesn't exist vote" do
      delete :nullify_vote, { id: voteable, format: :json }
      expect(JSON.parse(response.body)['errors']).to eq "Вы не можете отменить голос не проголосовав!"
    end
  end
end
