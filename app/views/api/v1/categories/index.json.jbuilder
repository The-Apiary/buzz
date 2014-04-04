json.categorys @categories do |category|
  json.partial! 'category', category: category
end

