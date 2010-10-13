Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'APPLICATION_ID', 'APPLICATION_SECRET'
end
