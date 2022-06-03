json.categories do
  json.array! @categories do |category|
    json.title category.title
    json.id category.id
  end
end
