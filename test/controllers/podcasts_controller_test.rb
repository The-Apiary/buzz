require 'test_helper'

class Api::V1::PodcastsControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = users(:active).id
    @podcast = podcasts(:jadiolab)
  end

  test 'should get index' do
    get :index, {format: 'json'}
    assert_response :success
    assert_not_nil assigns(:podcasts)
  end

  test "should create podcast" do
    assert_difference('Podcast.count') do
      post :create, podcast: { feed_url: @podcast.feed_url }
    end
  end


  test "should show podcast" do
    get :show, { id: @podcast, format: :json }
    assert_response :success
  end
end
