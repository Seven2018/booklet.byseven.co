json.tags do
  json.array! @tags do |tag|
    json.tag_name tag.tag_name
    json.id tag.id
  end
end
