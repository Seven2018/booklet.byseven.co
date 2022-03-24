Cloudinary.config do |config|
  # config.cloud_name = Rails.application.credentials.cloudinary_cloud_name
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  # config.api_key = Rails.application.credentials.cloudinary_api_key
  config.api_key = ENV['CLOUDINARY_API_KEY']
  # config.api_secret = Rails.application.credentials.cloudinary_api_secret
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure = true
  config.cdn_subdomain = true
end
