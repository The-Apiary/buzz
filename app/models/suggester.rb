class Suggester
  def self.episodes(user, type, sample=false)
    return sample(user, type) if sample

    case type
    when "News"
      self.news(user)
    when "Serial"
      self.serial(user)
    else
      self.normal(user)
    end
  end

  def self.news(user, date=1.week.ago)
    type = "News"
    Episode
      .unscoped
      .distinct_podcasts
      .subscribed(user, type: type)
      .unplayed(user)
      .newer_than(date)
      .freshest
  end

  def self.serial(user)
    type = "Serial"
    Episode
      .unscoped
      .distinct_podcasts
      .subscribed(user, type: type)
      .unplayed(user)
      .oldest
  end

  def self.normal(user)
    type = "Normal"
    Episode
      .unscoped
      .distinct_podcasts
      .subscribed(user, type: type)
      .unplayed(user)
      .freshest
      .order_groups("random()")
  end

  def self.sample(user, type)
    case type
    when "News"
      podcasts = [
        "http://www.npr.org/rss/podcast.php?id=35",        # NPR: Wait Wait... Don't Tell Me! Podcast
        "http://www.marketplace.org/node/all/podcast.xml", # APM: Marketplace All-In-One
        "http://www.npr.org/rss/podcast.php?id=510299" ,   # NPR: Ask Me Another Podcast
        "http://www.npr.org/rss/podcast.php?id=500005" ,   # NPR: Hourly News Summary Podcast
      ]
      puts podcasts
      Episode
        .unscoped
        .distinct_podcasts
        .where(podcast: Podcast.where(feed_url: podcasts))
        .unplayed(user)
        .newer_than(1.week.ago)
        .freshest
    when "Serial"
      podcasts = [
        "http://feeds.serialpodcast.org/serialpodcast",   # Serial
        "http://bornyesterdaypodcast.com//rss",           # The Born Yesterday Podcast
        "http://feeds.feedburner.com/thetruthapm",        # The Truth
        "http://thrillingadventurehour.libsyn.com/rss",   # Thrilling Adventure Hour
        "http://feeds.feedburner.com/WelcomeToNightVale", # Welcome to Night Vale
      ]
      Episode
        .unscoped
        .distinct_podcasts
        .where(podcast: Podcast.where(feed_url: podcasts))
        .unplayed(user)
        .oldest
    else
      podcasts = [
        "http://feeds.99percentinvisible.org/99percentinvisible", # 99% Invisible
        "http://www.npr.org/rss/podcast.php?id=510289",           # NPR: Planet Money Podcast
        "http://songexploder.libsyn.com/rss",                     # Song Exploder
        "http://feeds.feedburner.com/AmericasTestKitchenRadio", # America's Test Kitchen Radio
        "http://www.startalkradio.net/feed/shows/",             # StarTalk Radio
        "http://feeds.feedburner.com/tciafpodcast",             # Third Coast International Audio Festival
        "http://feeds.thisamericanlife.org/talpodcast",         # This American Life
      ]
      Episode
        .unscoped
        .distinct_podcasts
        .where(podcast: Podcast.where(feed_url: podcasts))
        .unplayed(user)
        .freshest
    end
  end
end
