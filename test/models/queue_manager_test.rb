require 'test_helper'

class QueueManagerTest < ActiveSupport::TestCase
  #-- Initialization

  test "#new: Should initialize with a user" do
    # How to test @user was set?
    user = create(:user)
    assert_nothing_raised ArgumentError do
      QueueManager.new(user)
    end
  end

  test "#new: Should fail to initialize without a user" do
    err = assert_raise ArgumentError do
      QueueManager.new(false)
    end

    assert_equal "Argument false must be User but was FalseClass", err.message
  end

  #-- Min/Max

  test "Should have a max index of 2147483647" do
    assert_equal 2147483647, QueueManager.max_idx
  end

  test "Should have a min index of 2147483648" do
    assert_equal (-2147483648), QueueManager.min_idx
  end

  #-- Clear

   test "#clear: Should delete all queued episodes" do
    user = create(:user)
    qm = QueueManager.new(user)

    n = 3
    n.times { user.queued_episodes.create(episode: create(:episode)) }
    assert_equal n, user.queued_episodes.count

    qm.clear

    assert_equal 0, user.queued_episodes.count
   end

  #-- Push

  test "push: Should create queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    assert_difference 'QueuedEpisode.count', 1 do
      qm.push(episode)
    end
  end

  test "push: Should not create duplicate queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    qm.push(episode)
    assert_no_difference 'QueuedEpisode.count' do
      qm.push(episode)
    end
  end

  test "push: Should add episodes to the end of the queue" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)
    qm.push(create(:episode))

    qe = qm.push(episode)
    assert_equal user.queued_episodes.last, qe
    assert_equal 2, user.queued_episodes.count
  end

  test "push: Should move episode if already exists" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    qm.push(episode)
    qm.push(create(:episode))
    assert_no_difference 'QueuedEpisode.count' do
      qe = qm.push(episode)
      assert_equal user.queued_episodes.last, qe
    end
  end

  test "push: Should return the modified queued episode" do
    user = create(:user)
    episode = create(:episode)
    other = create(:episode)

    qm = QueueManager.new(user)
    qm.push(other)

    qe = qm.push episode

    assert_instance_of QueuedEpisode, qe
    assert episode, qe.episode
  end

  #-- unshift

  test "unshift: Should create queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    assert_difference 'QueuedEpisode.count', 1 do
      qm.unshift(episode)
    end
  end

  test "unshift: Should not create duplicate queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    qm.push(episode)
    assert_no_difference 'QueuedEpisode.count' do
      qm.unshift(episode)
    end
  end

  test "unshift: Should add episodes to the beginning of the queue" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)
    qm.push(create(:episode))

    qe = qm.unshift(episode)
    assert_equal user.queued_episodes.first, qe
    assert_equal 2, user.queued_episodes.count
  end

  test "push: Should move episode to front if already exists" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    qm.push(create(:episode))
    qm.push(episode)
    assert_no_difference 'QueuedEpisode.count' do
      qe = qm.unshift(episode)
      assert_equal user.queued_episodes.first, qe
    end
  end

  test "unshift: Should return the modified queued episode" do
    user = create(:user)
    episode = create(:episode)
    other = create(:episode)

    qm = QueueManager.new(user)
    qm.push(other)

    qe = qm.unshift episode

    assert_instance_of QueuedEpisode, qe
    assert episode, qe.episode
  end

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
    user.queued_episodes.create(episode: e, idx: QueueManager.max_idx)

    assert_difference 'user.queued_episodes.count', 1 do
      qm.push(create(:episode))
      assert_equal true, qm.rebased?
    end
  end

  test "Should rebase when head gets too crowded" do
    user = create(:user)
    qm = QueueManager.new(user)

    e = create(:episode)
    user.queued_episodes.create(episode: e, idx: QueueManager.min_idx)

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
