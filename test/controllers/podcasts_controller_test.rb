require 'test_helper'

class Api::V1::PodcastsControllerTest < ActionController::TestCase
  setup do
    # Login user one
    @current_user = create(:user)
    signin @current_user
  end

  test 'should get index' do
    podcast = create(:podcast)
    create(:subscription, podcast: podcast)
    create(:subscription, user: @current_user, podcast: podcast)
    get :index, {format: 'json'}
    assert_response :success
    assert_equal assigns(:podcasts), @current_user.podcasts
  end

  test 'should create new podcast' do
    feed_url = attributes_for(:podcast)[:feed_url]
    assert_difference('Podcast.count') do
      post :create, { podcast: { feed_url: feed_url }, format: :json }
      assert_response :success
      assert_not_nil assigns(:podcast)
    end
  end

  test 'should not create duplicate podcast' do
    podcast = create(:podcast)
    assert_no_difference('Podcast.count') do
      post :create, { podcast: { feed_url: podcast.feed_url }, format: :json }
      assert_response :success
      assert_equal assigns(:podcast), podcast
    end
  end

  test "should show podcast" do
    podcast = create(:podcast)
    get :show, { id: podcast, format: :json }
    assert_response :success
    assert_equal assigns(:podcast), podcast
  end
end
