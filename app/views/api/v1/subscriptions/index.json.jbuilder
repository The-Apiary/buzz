json.subscriptions @subscriptions do |subscription|
  json.partial! 'subscription', subscription: subscription
end

json.podcasts @podcasts do |podcast|
  json.partial! 'api/v1/podcasts/podcast', podcast: podcast
end
