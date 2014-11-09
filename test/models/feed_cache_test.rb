require 'test_helper'


describe FeedCache do

  let(:feed_url) { "dummy feed" }
  let(:ttl) { 1.hour }

  # Stubs File methods to fake an feed file that may exist, and has an mtime.
  def with_feed_that(exists: exists, is_fresh: is_fresh = false, &block)
    mtime = (is_fresh ? ttl - 15.minutes : ttl + 15.minutes).ago

    context = -> (&inner_block) do
      File.stub :exist?, exists do
        File.stub :mtime, mtime do
          inner_block.call
        end
      end
    end

    block_given? ? context.call(&block) : context
  end

  context 'when feed doesnt exist' do
    subject { with_feed_that exists: false }

    describe '#cached?' do
      it 'should be false' do
        subject.call do
          refute FeedCache.cached? feed_url, ttl
        end
      end
    end

    describe '#open' do
      it 'should open the file with FeedCache#get' do
        obj = Object.new
        subject.call do
          FeedCache.stub :get, obj do
            assert_same FeedCache.open(feed_url), obj,
              "expected FeedCache#open to return the value of Kernel#open"
          end
        end
      end
    end

  end

  context 'when feed exists but is older than TTL' do
    subject { with_feed_that exists: true, is_fresh: false }

    describe '#cached?' do
      it 'should be false' do
        subject.call do
          refute FeedCache.cached? feed_url, ttl
        end
      end
    end

    describe '#open' do
      it 'should open the file with FeedCache#get' do
        obj = Object.new
        subject.call do
          FeedCache.stub :get, obj do
            assert_same FeedCache.open(feed_url), obj,
              "expected FeedCache#open to return the value of Kernel#open"
          end
        end
      end
    end

  end

  context 'when feed exists and is newer than TTL' do
    subject { with_feed_that exists: true, is_fresh: true }

    describe '#cached?' do
      it 'should be true' do
        subject.call do
          assert FeedCache.cached? feed_url, ttl
        end
      end
    end

    describe '#open' do
      it 'should open the file with Kernel#open' do
        obj = Object.new
        subject.call do
          Kernel.stub :open, obj do
            assert_same FeedCache.open(feed_url), obj,
              "expected FeedCache#open to return the value of Kernel#open"
          end
        end
      end
    end

  end

end
