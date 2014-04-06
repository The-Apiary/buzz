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

  #-- Shift

  test "shift: Should create queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    assert_difference 'QueuedEpisode.count', 1 do
      qm.shift(episode)
    end
  end

  test "shift: Should not create duplicate queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    qm.push(episode)
    assert_no_difference 'QueuedEpisode.count' do
      qm.shift(episode)
    end
  end

  test "shift: Should add episodes to the beginning of the queue" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)
    qm.push(create(:episode))

    qe = qm.shift(episode)
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
      qe = qm.shift(episode)
      assert_equal user.queued_episodes.first, qe
    end
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
      qe = qm.add_between(episode, after: e1, before: e2)
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
      qm.add_between(episode, after: e1, before: e2)

      assert_equal user.queued_episodes.first.episode, e1
      assert_equal user.queued_episodes.last.episode, e2
    end
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
      qm.add_between(create(:episode), after: e1, before: e2)
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
      qm.shift(create(:episode))
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
