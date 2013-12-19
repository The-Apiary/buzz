feed_urls = [
  'http://americanpublicmedia.publicradio.org/podcasts/xml/dinner-party/podcast.xml',
  'http://bornyesterdaypodcast.com//rss',
  'http://feeds.99percentinvisible.org/99percentinvisible',
  'http://feeds.feedburner.com/SlateCultureGabfest?format=xml',
  'http://feeds.feedburner.com/SlateLexiconValley',
  'http://feeds.feedburner.com/WelcomeToNightVale',
  'http://feeds.feedburner.com/dancarlin/history?format=xml',
  'http://feeds.feedburner.com/risk-show/yWzy?format=xml',
  'http://feeds.feedburner.com/tciafpodcast',
  'http://feeds.feedburner.com/thetruthapm',
  'http://feeds.prx.org/toe',
  'http://feeds.soundcloud.com/users/soundcloud:users:13270730/sounds.rss',
  'http://feeds.themoth.org/themothpodcast',
  'http://feeds.thisamericanlife.org/talpodcast',
  'http://feeds.wnyc.org/onthemedia',
  'http://feeds.wnyc.org/radiolab',
  'http://nerdist.libsyn.com/rss',
  'http://rubyrogues.com/feed/',
  'http://thrillingadventurehour.libsyn.com/rss',
  'http://www.howstuffworks.com/podcasts/stuff-you-should-know.rss',
  'http://www.kcrw.com/music/programs/mb/RSS',
  'http://www.kcrw.com/news/programs/in/RSS',
  'http://www.kcrw.com/news/programs/lr/RSS',
  'http://www.marketplace.org/node/all/podcast.xml',
  'http://www.npr.org/rss/podcast.php?id=35',
  'http://www.npr.org/rss/podcast.php?id=510184',
  'http://www.npr.org/rss/podcast.php?id=510184',
  'http://www.npr.org/rss/podcast.php?id=510282',
  'http://www.npr.org/rss/podcast.php?id=510294',
  'http://www.npr.org/rss/podcast.php?id=510298',
  'http://www.npr.org/rss/podcast.php?id=510299',
  'http://www.startalkradio.net/feed/shows/',
  'http://www.tatw.co.uk/podcast.xml',
  'http://www.thesoundsinmyhead.com/rss.xml',
]

puts "Createing feeds"
feed_urls.each do |url|
  podcast = Podcast.new feed_url: url

  p podcast.errors.to_a unless podcast.save

  puts "-- title: #{podcast.title}"
  puts "   feed_url: #{podcast.feed_url}"
  puts "   image_url: #{podcast.image_url}"
  puts "   description: #{podcast.description}"
  puts "   episodes: #{podcast.episodes.count}"
end

puts "Now #{Podcast.count} feeds"
