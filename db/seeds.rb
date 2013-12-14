feed_urls = [
  'http://rubyrogues.com/feed/',
  'http://www.startalkradio.net/feed/shows/',
  'http://www.npr.org/rss/podcast.php?id=35',
  'http://www.npr.org/rss/podcast.php?id=510299',
  'http://www.kcrw.com/news/programs/lr/RSS',
  'http://feeds.wnyc.org/onthemedia',
  'http://www.marketplace.org/node/all/podcast.xml',
  'http://www.tatw.co.uk/podcast.xml',
  'http://www.kcrw.com/music/programs/mb/RSS',
  'http://www.thesoundsinmyhead.com/rss.xml',
  'http://www.howstuffworks.com/podcasts/stuff-you-should-know.rss',
  'http://feeds.feedburner.com/dancarlin/history?format=xml',
  'http://www.kcrw.com/news/programs/in/RSS',
  'http://bornyesterdaypodcast.com//rss',
  'http://feeds.99percentinvisible.org/99percentinvisible',
  'http://feeds.prx.org/toe',
  'http://www.npr.org/rss/podcast.php?id=510298',
  'http://feeds.wnyc.org/radiolab',
  'http://feeds.feedburner.com/risk-show/yWzy?format=xml',
  'http://feeds.soundcloud.com/users/soundcloud:users:13270730/sounds.rss',
  'http://feeds.feedburner.com/WelcomeToNightVale',
  'http://feeds.feedburner.com/tciafpodcast',
  'http://feeds.themoth.org/themothpodcast',
  'http://feeds.thisamericanlife.org/talpodcast',
  'http://thrillingadventurehour.libsyn.com/rss',
  'http://feeds.feedburner.com/thetruthapm',
  'http://feeds.feedburner.com/SlateCultureGabfest?format=xml',
  'http://riyl.podbean.com/feed/',
  'http://www.npr.org/rss/podcast.php?id=510282',
  'http://americanpublicmedia.publicradio.org/podcasts/xml/dinner-party/podcast.xml',
  'http://nerdist.libsyn.com/rss',
  'http://jonahraydio.libsyn.com/rss'
]

puts "Createing feeds"
feed_urls.each do |url|
  podcast = Podcast.new feed_url: url
  p podcast.errors.to_a unless podcast.save
end

puts "Now #{Podcast.count} feeds"
