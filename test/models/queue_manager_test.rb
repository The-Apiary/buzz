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

  #-- Queueing

  test "enqueue: Should create queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    assert_difference 'QueuedEpisode.count', 1 do
      qm.enqueue(episode)
    end
  end

  test "enqueue: Should not create duplicate queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    qm.enqueue(episode)
    assert_no_difference 'QueuedEpisode.count' do
      qm.enqueue(episode)
    end
  end

  test "enqueue: Should add episodes to the end of the queue" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)
    qm.enqueue(create(:episode))

    qe = qm.enqueue(episode)
    assert_equal user.queued_episodes.last, qe
    assert_equal 2, user.queued_episodes.count
  end

  #-- Head queue

  test "head_enqueue: Should create queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    assert_difference 'QueuedEpisode.count', 1 do
      qm.head_enqueue(episode)
    end
  end

  test "head_enqueue: Should not create duplicate queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)

    qm.enqueue(episode)
    assert_no_difference 'QueuedEpisode.count' do
      qm.head_enqueue(episode)
    end
  end

  test "head_enqueue: Should add episodes to the beginning of the queue" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)
    qm.enqueue(create(:episode))

    qe = qm.head_enqueue(episode)
    assert_equal user.queued_episodes.first, qe
    assert_equal 2, user.queued_episodes.count
  end


  #-- Dequeue

  test "dequeue: Should delete queued episodes" do
    user = create(:user)
    episode = create(:episode)

    qm = QueueManager.new(user)
    qm.enqueue(episode)

    assert_difference 'QueuedEpisode.count', -1 do
      qm.dequeue(episode)
    end
  end
end
