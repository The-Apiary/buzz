class Suggester
  def self.episodes(user, type)
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
      .randomize
  end
end
