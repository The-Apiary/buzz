require 'test_helper'

class QueueManagerTest < ActiveSupport::TestCase
  #-- Add between

  test "add_between: Should create queeud episode" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    e1 = create(:episode)
    e2 = create(:episode)

    qm.push e1
    qm.push e2
    assert_difference 'QueuedEpisode.count', 1 do
      qe = qm.add_between(episode, e1, e2)
      assert_equal episode, qe.episode
    end
  end

  test "add_between: Should add queeud episode between others" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    e1 = create(:episode)
    e2 = create(:episode)

    qm.push e1
    qm.push e2
    assert_difference 'QueuedEpisode.count', 1 do
      qm.add_between(episode, e1, e2)

      assert_equal user.queued_episodes.first.episode, e1
      assert_equal user.queued_episodes.last.episode, e2
    end
  end

  test "add_between: Should return the modified queued episode" do
    user = create(:user)
    episode = create(:episode)
    before = create(:episode)
    after = create(:episode)

    qm = QueueManager.new(user)
    qm.push(before)
    qm.push(after)

    qe = qm.add_between episode, after, before

    assert_instance_of QueuedEpisode, qe
    assert episode, qe.episode
  end

  #-- Add After

  test "add_after: Should create queued episode after other episode" do
    user = create(:user)
    episode = create(:episode)
    after = create(:episode)

    qm = QueueManager.new(user)

    4.times { qm.push(create(:episode)) }
    qm.push(after)
    4.times { qm.push(create(:episode)) }

    assert_difference 'QueuedEpisode.count', 1 do
      qm.add_after(episode, after)
    end

    after_idx = user.queued_episodes.index {|qe| qe.episode == after }
    episode_idx = user.queued_episodes.index {|qe| qe.episode == episode }
    assert_equal after_idx + 1, episode_idx
  end

  test "add_after: Should create queued episode after other episode at end of queue" do
    user = create(:user)
    episode = create(:episode)
    after = create(:episode)

    qm = QueueManager.new(user)

    4.times { qm.push(create(:episode)) }
    qm.push(after)

    assert_difference 'QueuedEpisode.count', 1 do
      qm.add_after(episode, after)
    end

    after_idx = user.queued_episodes.index {|qe| qe.episode == after }
    episode_idx = user.queued_episodes.index {|qe| qe.episode == episode }
    assert_equal after_idx + 1, episode_idx
  end

  test "add_after: Should return the modified queued episode" do
    user = create(:user)
    episode = create(:episode)
    after = create(:episode)

    qm = QueueManager.new(user)
    qm.push(after)

    qe = qm.add_after episode, after

    assert_instance_of QueuedEpisode, qe
    assert episode, qe.episode
  end

  #-- Add Before

  test "add_before: Should create queued episode before other episode" do
    user = create(:user)
    episode = create(:episode)
    before = create(:episode)

    qm = QueueManager.new(user)

    4.times { qm.push(create(:episode)) }
    qm.push(before)
    4.times { qm.push(create(:episode)) }

    assert_difference 'QueuedEpisode.count', 1 do
      qm.add_before(episode, before)
    end

    before_idx = user.queued_episodes.index {|qe| qe.episode == before }
    episode_idx = user.queued_episodes.index {|qe| qe.episode == episode }
    assert_equal before_idx - 1, episode_idx
  end

  test "add_before: Should create queued episode before other episode at beginning of queue" do
    user = create(:user)
    episode = create(:episode)
    before = create(:episode)

    qm = QueueManager.new(user)

    qm.push(before)
    4.times { qm.push(create(:episode)) }

    assert_difference 'QueuedEpisode.count', 1 do
      qm.add_before(episode, before)
    end

    before_idx = user.queued_episodes.index {|qe| qe.episode == before }
    episode_idx = user.queued_episodes.index {|qe| qe.episode == episode }
    assert_equal before_idx - 1, episode_idx
  end

  test "add_before: Should return the modified queued episode" do
    user = create(:user)
    episode = create(:episode)
    before = create(:episode)

    qm = QueueManager.new(user)
    qm.push(before)

    qe = qm.add_before episode, before

    assert_instance_of QueuedEpisode, qe
    assert episode, qe.episode
  end

  #-- Remove

  test "Remove: Should delete queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)
    qm.push(episode)

    assert_difference 'QueuedEpisode.count', -1 do
      qm.remove(episode)
    end
  end

  #-- Rebase test

  test "Should rebase when gap gets too small" do
    user = create(:user)
    qm = QueueManager.new(user)

    e1 = create(:episode)
    e2 = create(:episode)
    user.queued_episodes.create(episode: e1, idx: 0)
    user.queued_episodes.create(episode: e2, idx: 1)

    assert_difference 'user.queued_episodes.count' do
      qm.add_between(create(:episode), e1, e2)
      assert_equal true, qm.rebased?
    end
  end

  test "Should rebase when tail gets too crowded" do
    user = create(:user)
    qm = QueueManager.new(user)

    e = create(:episode)
    user.queued_episodes.create(episode: e, idx: QueueManager.MAX_IDX)

    assert_difference 'user.queued_episodes.count', 1 do
      qm.push(create(:episode))
      assert_equal true, qm.rebased?
    end
  end

  test "Should rebase when head gets too crowded" do
    user = create(:user)
    qm = QueueManager.new(user)

    e = create(:episode)
    user.queued_episodes.create(episode: e, idx: QueueManager.MIN_IDX)

    assert_difference 'user.queued_episodes.count', 1 do
      qm.unshift(create(:episode))
      assert_equal true, qm.rebased?
    end
  end

  test "Should be able to push 32 episodes without rebasing" do
    user = create(:user)
    qm = QueueManager.new(user)

    order = 32.times.map { qm.push(create(:episode))}
    assert_equal false, qm.rebased?
    assert_equal order, user.queued_episodes

    assert_difference 'user.queued_episodes.count', 1 do
      order << qm.push(create(:episode))
      assert_equal true, qm.rebased?

      user.reload
      assert_equal order.count, user.queued_episodes.count
      assert_equal order, user.queued_episodes
    end
  end

end

describe QueueManager do
  before do
    @user = create(:user)
    @qm = QueueManager.new(@user)
  end

  after { @user.destroy! }

  desc "When initialized without a user" do
    it "should raise an argument error" do
      assert_raises ArgumentError do
        QueueManager.new(nil)
      end
    end
  end

  desc "Constants" do
    it "should have MAX_IDX index of 2147483647" do
      assert_equal 2147483647, QueueManager.MAX_IDX
    end

    it "should have MIN_IDX index of -2147483648" do
      assert_equal (-2147483648), QueueManager.MIN_IDX
    end
  end

  desc "#clear" do
    before do
      10.times { @user.queued_episodes.create(episode: create(:episode)) }
    end

    it "should delete all queued episdoes" do
      @qm.clear
      assert_equal 0, @user.queued_episodes.count
    end
  end

  desc "#push" do
    before do
      @episode = create(:episode)
      @qm.push(create(:episode))
      @push_return =  @qm.push(@episode)
    end

    it "should return a queued episode" do
      assert_instance_of QueuedEpisode, @push_return
      assert_equal @push_return.episode, @episode
    end

    it "should create a queued epsidoe with the highest idx" do
      highest_idx = QueuedEpisode.where(user: @user).pluck(:idx).max

      assert_equal highest_idx, @push_return.idx
    end

    context "with a queued episode" do
      before do
        @qm.push(@episode)
      end

      it "should queue the episode" do
        assert_no_difference '@user.queued_episodes.count' do
          @qm.push(@episode)
        end
      end

      it "should move the queued_episode to the end of the queue" do
        assert_equal @push_return, @user.queued_episodes.last
      end
    end
  end

  desc "#unshift" do
    before do
      @episode = create(:episode)
      @qm.unshift(create(:episode))
      @unshift_return =  @qm.unshift(@episode)
    end

    it "should return a queued episode" do
      assert_instance_of QueuedEpisode, @unshift_return
      assert_equal @unshift_return.episode, @episode
    end

    it "should create a queued epsidoe with the lowest idx" do
      lowest_idx = QueuedEpisode.where(user: @user).pluck(:idx).min

      assert_equal lowest_idx, @unshift_return.idx
    end

    context "with a queued episode" do
      before do
        @qm.unshift(@episode)
      end

      it "should queue the episode" do
        assert_no_difference '@user.queued_episodes.count' do
          @qm.unshift(@episode)
        end
      end

      it "should move the queued_episode to the front of the queue" do
        assert_equal @unshift_return, @user.queued_episodes.first
      end
    end
  end

end
