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
end
