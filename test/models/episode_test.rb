require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  test "episode_data: Should be nil if episode_data doesn't exist" do
    user = create(:user)
    episode = create(:episode)

    assert_nil episode.episode_data(user)
  end

  test "episode_data: Should get the users episode data" do
    user = create(:user)
    episode = create(:episode)
    ed = EpisodeData.create(user: user, episode: episode)

    assert_not_nil episode.episode_data(user)
    assert_equal ed, episode.episode_data(user)
  end

  test "current_position: Should be 0 when there is no episode data" do
    user = create(:user)
    episode = create(:episode)

    assert_equal 0, episode.current_position(user)
  end

  test "current_position: Should be episode_data.current_position when ed exists" do
    user = create(:user)
    episode = create(:episode)
    n = 100
    EpisodeData.create(user: user, episode: episode, current_position: n)

    assert_equal n, episode.current_position(user)
  end

  test "is_played: Should be false when there is no episode data" do
    user = create(:user)
    episode = create(:episode)

    assert_equal false, episode.is_played(user)
  end

  test "is_played: Should be episode_data.is_played when ed exists" do
    user = create(:user)
    episode = create(:episode)
    n = true
    EpisodeData.create(user: user, episode: episode, is_played: n)

    assert_equal n, episode.is_played(user)
  end
end
