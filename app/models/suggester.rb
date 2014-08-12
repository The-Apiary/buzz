class Suggester

  ##
  # Returns a set of episodes the user might be interested in listening to.
  def self.episodes(user, n=10)
    grouped_subscriptions = user.subscriptions.group_by(&:subscription_type)
    grouped_subscriptions.map do |type, subs|
      podcasts = subs.map(&:podcast)
      Suggester.type_episodes(type, podcasts, user, n)
    end.flatten
  end

  private

  def self.type_episodes(type, podcasts, user, n=10)
      podcasts
        .shuffle
        .lazy
        .map { |podcast| Suggester.podcast_episode(type, podcast, user) }
        .reject(&:nil?)
        .take(n)
        .to_a
  end

  ##
  # Returns an array of no more than +n+ suggested episodes from the
  # array of +podcasts+
  def self.podcast_episode(type, podcast, user)
    episodes = case type
    when "News"
      podcast.episodes.freshest.newer_than(1.week.ago)
    when "Serial"
      podcast.episodes.freshest.reverse
    else
      podcast.episodes.shuffle
    end

    episodes
      .drop_while { |e| e.is_played(user) }
      .first
  end

  def self.news(user, date=1.week.ago)
    type = "News"
    Episode
      .unscoped
      .select("DISTINCT ON (episodes.podcast_id) episodes.*")
      .subscribed(user, type: type)
      .unplayed(user)
      .newer_than(date)
      .order("episodes.podcast_id") # DISTINCT ON Must be ordered
      .freshest
  end

  def self.serial(user)
    type = "Serial"
    Episode
      .unscoped
      .select("DISTINCT ON (episodes.podcast_id) episodes.*")
      .subscribed(user, type: type)
      .unplayed(user)
      .order("episodes.podcast_id") # DISTINCT ON Must be ordered
      .oldest
  end

  def self.normal(user)
    type = "Normal"
    Episode
      .unscoped
      .select("DISTINCT ON (episodes.podcast_id) episodes.*")
      .subscribed(user, type: type)
      .unplayed(user)
      .order("episodes.podcast_id") # DISTINCT ON Must be ordered
      .freshest
  end
end
