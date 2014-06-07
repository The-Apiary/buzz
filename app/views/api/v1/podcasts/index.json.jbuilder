json.podcasts @podcasts do |podcast|
  json.partial! 'podcast', podcast: podcast
end

json.meta do
  json.limit @limit
  json.offset @offset
  json.total @total
end
