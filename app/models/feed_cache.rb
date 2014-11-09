require 'open-uri'
class FeedCache
  # Where feeds should be downloaded to
  @@cache_dir = Rails.configuration.feed_cache_dir
  # How old a cached feed can be before it expires
  @@default_ttl = Rails.configuration.feed_cache_ttl

  def self.cached? feed, ttl=@@default_ttl
    File.exist?(cache_file(feed)) && (File.mtime(cache_file(feed)) >= ttl.ago)
  end

  # Add a file to the cache
  def self.get(feed)
    tf = Kernel.open feed

    # Open returns a StringIO when the reponse is short.
    if tf.is_a? StringIO
      File.open(cache_file(feed), 'w') do |f|
        tf.each_line do |line|
          f.write(line.force_encoding("UTF-8"))
        end
      end
    else
      FileUtils.cp(tf, cache_file(feed))
    end

    Kernel.open cache_file(feed)
  end

  # Return the cached version of a feed or get and add it to the cashe
  def self.open feed, ttl=@@default_ttl
    create_cache

    if cached?(feed, ttl)
      Kernel.open cache_file(feed)
    else
      get(feed)
    end
  end

  private

  # Create the cache file if it doesn't exist
  def self.create_cache
    Dir.mkdir @@cache_dir unless Dir.exist?(@@cache_dir)
  end

  # SHA1's the feed's url and returns the full path to where this feed
  # should be cached.
  def self.cache_file feed
    File.join(@@cache_dir, Digest::SHA1.hexdigest(feed))
  end
end
