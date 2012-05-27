Instagram.configure do |config|
  config.client_id = ENV['INSTA_CLIENT_ID']
  config.client_secret = ENV['INSTA_CLIENT_SECRET']
end

CALLBACK_URL = "http://localhost:5000/sessions/callback"

