json.podcasts @podcasts do |podcast|
  json.partial! 'podcast', podcast: podcast
end

