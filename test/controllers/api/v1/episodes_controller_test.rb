require 'test_helper'

class Api::V1::EpisodesControllerTest < ActionController::TestCase
  test "data: Should create new episode_data if one doesn't exist" do
    user = create(:user)
    episode = create(:episode)

    signin user

    assert_difference('EpisodeData.count', 1) do
      post :data, { format: :json, id: episode.id }
    end

    assert_not_nil episode.episode_data(user)
  end

  test "data: Should set values when created" do
    user = create(:user)
    episode = create(:episode)

    signin user

    pos = 100
    is_played = true
    assert_difference('EpisodeData.count', 1) do
      post :data, { format: :json, id: episode.id, current_position: pos, is_played: is_played }
    end

    assert_not_nil episode.episode_data(user)
    assert_equal pos, episode.current_position(user)
    assert_equal is_played, episode.is_played(user)
  end
end
