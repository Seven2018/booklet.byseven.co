json.templates do
  json.array! @templates do |template|
    json.title template.title
    json.url interview_form_path(template)
    json.id template.id
  end
end
