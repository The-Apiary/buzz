require 'open-uri'
class FeedCache
  # Where feeds should be downloaded to
  @@cache_dir = File.join(Rails.root, 'tmp', 'feeds')
  # How old a cached feed can be before it expires
  @@default_ttl = 1.hour

  def self.create_cache
    Dir.mkdir @@cache_dir unless Dir.exist?(@@cache_dir)
  end

  def self.cache_file feed
    File.join(@@cache_dir, Digest::SHA1.hexdigest(feed))
  end

  def self.cached? feed, ttl=@@default_ttl
    File.exist?(cache_file(feed)) && (File.mtime(cache_file(feed)) >= ttl.ago)
  end

  # Add a file to the cache
  def self.get(feed)
    tf = Kernel.open feed

    # Open returns a StringIO when the reponse is short.
    if tf.is_a? StringIO
      File.open(cache_file(feed), 'w') do |f|
        tf.lines { |line| f.write(line) }
      end
    else
      FileUtils.cp(tf, cache_file(feed))
    end

    Kernel.open cache_file(feed)
  end

  # Return the cached version of a feed or get and add it to the hash
  def self.open feed, ttl=@@default_ttl
    create_cache

    Rails.logger.tagged(:feed_cache) { Rails.logger.info cache_file(feed) }

    unless cached?(feed, ttl)
      Rails.logger.tagged(:feed_cache, :miss) { Rails.logger.info feed }
      get(feed)
    else
      Rails.logger.tagged(:feed_cache, :hit) { Rails.logger.info feed }
      Kernel.open cache_file(feed)
    end

  end
end
