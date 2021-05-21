json.categories do
  json.array! @categories do |category|
    json.title category.title
    json.url category_path(category)
    json.id category.id
  end
end
