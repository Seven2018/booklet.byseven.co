json.users do
  json.array! @users do |user|
    json.name user.fullname
    json.id user.id
  end
end
