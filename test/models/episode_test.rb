require 'test_helper'

describe Episode do

  before { @episode = create(:episode) }
  after  { @episode.destroy }

  describe '#podcast' do
    it 'can belong to a podcast' do
      assert_instance_of Podcast, @episode.podcast
    end
  end

  describe '#queued_episodes' do
    it 'has many episodes' do
      assert_instance_of QueuedEpisode::ActiveRecord_Associations_CollectionProxy, @episode.queued_episodes
    end

    it 'should be dependant on the episode' do
      queued_episode = @episode.queued_episodes.create(user: create(:user))

      @episode.destroy

      assert_destroyed queued_episode
    end
  end

  describe '#episode_datas' do
    it 'has many episode datas' do
      assert_instance_of EpisodeData::ActiveRecord_Associations_CollectionProxy, @episode.episode_datas
    end

    it 'should be dependant on the episode' do
      episode_data = @episode.episode_datas.create(user: create(:user))

      @episode.destroy

      assert_destroyed episode_data
    end
  end

  describe '#title' do
    it 'should not be blank' do
      assert_cannot_be_blank build(:episode), :title
    end
  end

  describe '#audio_url' do
    it 'should not be blank' do
      assert_cannot_be_blank build(:episode), :audio_url
    end

    it 'should be unique' do
      episode = build(:episode, audio_url: @episode.audio_url)

      assert_invalid episode, :audio_url, "has already been taken"
    end
  end

  describe '#publication_date' do
    it 'should not be blank' do
      assert_cannot_be_blank build(:episode), :publication_date
    end
  end

  describe '#guid' do
    it 'can be blank' do
      episode = build(:episode, guid: nil)
      assert_valid episode
    end

    it 'should be unique' do
      episode = build(:episode, guid: @episode.guid)

      assert_invalid episode, :guid, "has already been taken"
    end

    it 'can be duplicate if it is blank' do
      create(:episode, guid: nil)
      assert_valid build(:episode, guid: nil)
    end
  end

  describe '#episode_type' do
    it 'cannot be blank' do
      assert_cannot_be_blank build(:episode), :episode_type
    end

    it 'must match the regex /audio/' do
      episode = build(:episode, episode_type: 'video')
      assert_invalid episode, :episode_type, "'video' does not contain 'audio'"
    end
  end

  describe 'default scope' do
    before do
      @episodes = 10.times.map do
        create(:episode, publication_date: rand(100).days.ago)
      end
    end

    after do
      @episodes.map(&:destroy)
    end

    it 'should order by descending publication date' do
      assert_order Episode, publication_date: :desc
    end
  end

  describe 'search scope' do
    before do
      @query = 'mark'

      # cases
      @cases =  [:upcase, :downcase, :titlecase].map do |_case|
        @query.method(_case).call
      end

      @positions = ['_', ' ', @query].permutation.map { |arr| arr.join('') }


      @episodes = (@cases + @positions).map do |title|
        create(:episode, title: title)
      end
    end

    after do
      @episodes.map(&:destroy)
    end

    it 'should search titles case insensitive' do
      [:upcase, :downcase, :titlecase].each do |_case|
        titles = Episode.search(@query.method(_case).call).pluck(:title)

        @cases.each do |title|
          assert titles.include?(title), ["Expected matched titles to contain #{title}",
            "  query: #{@query}",
            "  matches: #{titles}",
            "  expected: #{title}"].join("\n")
        end
      end
    end

    it 'should match search in the title' do
        titles = Episode.search(@query).pluck(:title)

        @positions.each do |title|
          assert titles.include?(title), ["Expected matched titles to contain #{title}",
            "  query: #{@query}",
            "  matches: #{titles}",
            "  expected: #{title}"].join("\n")
        end
    end
  end

  describe '#parse_feed' do
    it 'is not tested yet' do
      skip "Cause I don't want to"
    end
  end

  describe 'user episode data' do

    before do
      @users = {
        this_user: create(:user),
        another_user: create(:user),
        decoy_user: create(:user),
      }

      # Create episode data for this and another user.
      # decoy user has no episode data.
      @episode_datas = {}
      [:this_user, :another_user].each do |user|
        @episode_datas[user] = @episode.episode_datas.create(user: @users[user])
      end

      @episode_datas[:this_user]
    end

    after do
      @users.map { |k, u| u.destroy! }
    end

    describe '#episode_data' do
      it 'must be called with a User' do
        [nil, '', [], @episode].each do |invalid_obj|
          assert_raises ArgumentError do
            @episode.episode_data(invalid_obj)
          end
        end
      end

      it 'should return the users episode data' do
        assert_equal @episode.episode_data(@users[:this_user]), @episode_datas[:this_user]
      end

      it 'should return nil if the user doesnt have an episode data' do
        assert_nil @episode.episode_data(@users[:decoy_user])
      end
    end

    describe '#current_position' do
      it 'must be called with a User' do
        [nil, '', [], @episode].each do |invalid_obj|
          assert_raises ArgumentError do
            @episode.current_position(invalid_obj)
          end
        end
      end

      it 'should return 0 if the user doesnt have an episode data' do
        assert_equal 0, @episode.current_position(@users[:decoy_user])
      end
    end

    describe '#is_played' do
      it 'must be called with a User' do
        [nil, '', [], @episode].each do |invalid_obj|
          assert_raises ArgumentError do
            @episode.is_played(invalid_obj)
          end
        end
      end

      it 'should return false if the user doesnt have an episode data' do
        assert_equal false, @episode.is_played(@users[:decoy_user])
      end
    end

    describe '#last_listened_at' do
      it 'must be called with a User' do
        [nil, '', [], @episode].each do |invalid_obj|
          assert_raises ArgumentError do
            @episode.last_listened_at(invalid_obj)
          end
        end
      end

      it 'should return nil if the user doesnt have an episode data' do
        assert_equal nil, @episode.last_listened_at(@users[:decoy_user])
      end
    end
  end
end
