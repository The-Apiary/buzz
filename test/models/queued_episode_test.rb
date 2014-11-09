require 'test_helper'


describe QueuedEpisode do

  before do
    @queued_episode = create(:queued_episode)
  end

  after do
    @queued_episode.destroy!
  end

  context "A queued episode" do
    desc "#episode" do
      it "should should be a single episode" do
        assert_instance_of Episode, @queued_episode.episode
      end

      context "when nil" do
        before do
          @nil_queued_episode = build(:queued_episode, episode: nil)
        end

        after { @nil_queued_episode.destroy! }

        it "should be invalid" do
          assert_invalid @nil_queued_episode, :episode
        end
      end

      context "with same episode and user" do
        before do
          @dup_queued_episode = build(:queued_episode,
                                      episode: @queued_episode.episode,
                                      user: @queued_episode.user)
        end

        it "should be invalid" do
          assert_invalid @dup_queued_episode, :episode
        end
      end


      context "with same episode but different user" do
        before do
          @dup_queued_episode = build(:queued_episode,
                                      episode: @queued_episode.episode)
        end

        it "should be invalid" do
          assert_valid @dup_queued_episode, :episode
        end
      end

    end

    desc "#user" do
      it "should be a single user" do
        assert_instance_of User, @queued_episode.user
      end

      context "when nil" do
        before do
          @nil_queued_episode = build(:queued_episode, user: nil)
        end

        after { @nil_queued_episode.destroy! }

        it "should be invalid" do
          assert_invalid @nil_queued_episode, :user_id
        end
      end

    end
  end

  context "default_scope" do
    it "Orders by idx" do
        assert_equal QueuedEpisode.all.order(idx: :asc), QueuedEpisode.all
    end
  end
end
