# Configure OmniAuth for facebook
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['BUZZ_FACEBOOK_APP_ID'], ENV['BUZZ_FACEBOOK_SECRET']
end
