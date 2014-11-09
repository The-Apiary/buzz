require 'test_helper'

describe Podcast do
  before do
    @podcast = create(:podcast)

    10.times do
      @podcast.episodes.create(attributes_for(:episode))
      @podcast.subscriptions.create(attributes_for(:subscription))
      @podcast.categories.create(attributes_for(:category))
    end
  end

  after do
    @podcast.destroy!
  end

  # General association tests.
  context "When loaded" do

    desc "#episodes" do
      it "should have many" do
        assert_instance_of Episode::ActiveRecord_Associations_CollectionProxy, @podcast.episodes
      end
    end

    desc "#subscriptions" do
      it "should have many" do
        assert_instance_of Subscription::ActiveRecord_Associations_CollectionProxy, @podcast.subscriptions
      end
    end

    desc "#categories" do
      it "should have many" do
        assert_instance_of Category::ActiveRecord_Associations_CollectionProxy, @podcast.categories
      end
    end

    desc 'default_scope' do
      it 'should order by title' do
        assert_equal Podcast.all.order(:title), Podcast.all
      end
    end

    desc 'alphabetic scope' do
      it 'should order by alphabetically by title' do
        assert_equal Podcast.all.order(:title), Podcast.alphabetic
      end
    end

    desc 'popular scope' do
      it 'should order by subscribers' do
        assert_equal Podcast.all.order('subscriptions_count desc'), Podcast.popular
      end
    end
  end

  context "When validated" do
    desc '#feed_url' do
      before do
        # Change this podcast's feed_url to that of an existing one.
        @podcast.feed_url = create(:podcast).feed_url
      end

      it 'should be unique' do
        assert_invalid @podcast, :feed_url, "has already been taken"
      end

      it 'cannot be blank' do
        assert_cannot_be_blank @podcast, :feed_url
      end
    end

    desc '#title' do
      it 'cannot be blank' do
        assert_cannot_be_blank @podcast, :title
      end
    end

    desc '#categories' do
      before do
        # Add a duplicate of the first category.
        @podcast.categories << @podcast.categories.first
      end

      it "should be unique" do
        assert_invalid @podcast, :categories, "cannot be repeated in the same podcast"
      end
    end
  end

  context "When destroyed" do
    before do
      # Destroy the podcast before running tests.
      @podcast.destroy
    end

    desc "#episodes" do
      it 'should also be destroyed' do
        assert_destroyed(*@podcast.episodes)
      end
    end

    desc "#subscriptions" do
      it 'should also be destroyed' do
        assert_destroyed(*@podcast.subscriptions)
      end
    end
  end

  context 'When searched' do
    desc 'title' do
      before do
        @query = 'marketplace'

        # cases
        @cases =  [:upcase, :downcase, :titlecase].map do |_case|
          title = @query.method(_case).call
          create(:podcast, title: title)
        end

        @positions = ['_', ' ', @query].permutation.map do |arr|
          title = arr.join('')
          create(:podcast, title: title)
        end
      end

      after do
        @cases.each(&:destroy!)
        @positions.each(&:destroy!)
      end

      it 'case should be ignored' do
        [:upcase, :downcase, :titlecase].each do |_case|
          # Search for the query in every case.
          results = Podcast.search(@query.method(_case).call)
          @cases.each do |_case|
            assert_includes results, _case
          end
        end
      end

      it 'substrings should be matched' do
        # Search for the query in every case.
        results = Podcast.search(@query)
        @positions.each do |position|
          assert_includes results, position
        end
      end
    end

    desc 'feed_url' do
      before do
        @query = 'string'
        @matched_podcasts = [create(:podcast, feed_url: @query)]
        @unmatched_podcasts = [create(:podcast, feed_url: "more #{@query}")]
      end

      after do
        @matched_podcasts.each(&:destroy!)
        @unmatched_podcasts.each(&:destroy!)
      end

      it 'should match the exact query' do
        @results = Podcast.search(@query)
        assert_equal @results, @matched_podcasts
      end
  end
  end

  desc '#add_category' do
    before do
      @cat = create(:category)
    end

    after do
      #assert_includes @podcast.categories.pluck(:name), @cat.name
      @cat.destroy!
    end

    it 'should return the added category' do
      assert_equal @cat, @podcast.add_category(@cat.name)
    end

    context 'When a category that podcast doesnt have is added' do
      it 'should add that category' do
        assert_difference '@podcast.categories.count', 1 do
          @podcast.add_category @cat.name
        end
      end
    end

    context 'When a duplicate category is added' do
      before do
        @podcast.add_category @cat.name
      end

      it 'should not add anything' do
        assert_no_difference '@podcast.categories.count' do
          @podcast.add_category @cat.name
        end
      end
    end

    context 'When a category that exists is added' do
      it 'should not create another category' do
        assert_no_difference 'Category.count' do
          @podcast.add_category @cat.name
        end
      end
    end

    context 'When a new category is added' do
      before do
        @cat.destroy!
      end

      it 'should create that categroy' do
        assert_difference 'Category.count', 1 do
          @podcast.add_category @cat.name
        end
      end
    end
  end

  desc '#category_names' do
    before do
      # remove the existing categories becasue we only want the ones
      # we create here to exist.
      @podcast.categories = []
      @names = 10.times.map { create(:category).name }
      @names.each { |name| @podcast.add_category name }
    end
    it 'should return an array of category names' do
      assert_equal @names, @podcast.category_names
    end
  end

  desc '#create_from_feed_url' do
    it 'should be tested' do
      skip
    end
  end

  desc '#parse_feed' do
    it 'should be tested' do
      skip
    end
  end
end
