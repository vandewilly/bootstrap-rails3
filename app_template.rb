repository_url = "https://github.com/jgeiger/bootstrap-rails3/raw/master"

# Remove normal files we don't want
%w(README public/index.html public/favicon.ico public/robots.txt public/images/rails.png).each do |f|
  remove_file f
end

# Gems, listed in alpha order

gem 'haml'
gem 'haml-rails'
gem 'mysql2'
gem 'warden'
gem 'devise'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'oauth2'
gem 'jammit'

gem 'kaminari'
gem 'simple_form'
gem 'uuidtools'

gem "capybara", :group => [:test, :cucumber]
gem 'database_cleaner', :group => [:test, :cucumber]
gem 'cucumber-rails', :group => [:test, :cucumber]
gem 'cucumber', :group => [:test, :cucumber]
gem 'spork', :group => [:test, :cucumber]
gem 'launchy', :group => [:test, :cucumber]    # So you can do Then show me the page
gem 'webrat', :group => [:test, :cucumber]
gem 'rspec', '>= 2.5.0', :group => [:test, :cucumber]
gem 'rspec-rails', '>= 2.5.0', :group => [:development, :test, :cucumber]
gem 'factory_girl_rails', :group => [:test, :cucumber]
gem 'fakeweb', :group => [:test, :cucumber]
gem 'rest-client', :group => [:test, :cucumber]
gem 'simplecov', :group => [:test, :cucumber]

generators = <<-GENERATORS

  config.generators do |g|
    g.template_engine :haml
    g.test_framework :rspec, :fixture => true, :views => false
  end
GENERATORS

application generators

#download javascript
get "http://code.jquery.com/jquery-1.5.1.js", "public/javascripts/jquery/jquery.js"
get "https://github.com/malsup/blockui/raw/master/jquery.blockUI.js", "public/javascripts/jquery/jquery.blockUI.js"
get "https://github.com/documentcloud/underscore/raw/master/underscore.js", "public/javascripts/lib/underscore.js"
get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/lib/rails.js"
get "https://github.com/nathansmith/formalize/blob/master/assets/javascripts/jquery.formalize.js", "public/javascripts/jquery/jquery.formalize.js"
get "http://www.modernizr.com/downloadfulljs/", "public/javascripts/lib/modernizr.js"
get "#{repository_url}/public/javascripts/lib/webfonts.js", "public/javascripts/lib/webfonts.js"

remove_file "public/javascripts/application.js"
get "#{repository_url}/public/javascripts/application.js", "public/javascripts/application.js"

['application', '_colors', '_flash_messages', '_fonts', '_forms', '_formalize', '_grid', '_layout', '_template', '_variables'].each do |file|
  get "#{repository_url}/public/stylesheets/sass/#{file}.scss", "public/stylesheets/sass/#{file}.scss"
end

# download images
get "https://github.com/nathansmith/formalize/blob/master/assets/images/button.png", "public/images/layout/button.png"
get "https://github.com/nathansmith/formalize/blob/master/assets/images/select_arrow.gif", "public/images/layout/select_arrow.gif"
get "#{repository_url}/public/images/layout/loading.gif", "public/images/layout/loading.gif"
['icons/success', 'icons/warning', 'icons/notice', 'icons/error', 'layout/logo'].each do |img|
  get "#{repository_url}/public/images/#{img}.png", "public/images/#{img}.png"
end

# download config
remove_file "config/routes.rb"
remove_file "config/locales/en.yml"
['assets.yml', 'locales/en.yml', 'routes.rb', 'initializers/mail.rb', 'mail.yml'].each do |file|
  get "#{repository_url}/config/#{file}", "config/#{file}"
end
get "#{repository_url}/db/migrate/001_devise_create_users.rb", "db/migrate/001_devise_create_users.rb"


# fix configs
gsub_file 'config/routes.rb', 'APP_NAME', "#{app_name.classify}"
gsub_file 'config/locales/en.yml', 'APP_NAME', "#{app_name}"
username = ask("Local database username (enter for root):")
password = ask("Local database password (enter for blank):")
username = username.blank? ? "root" : username
puts "Setting database username to #{username}"
puts "Setting database password to #{password}"
gsub_file 'config/database.yml', 'username: root', "username: #{username}"
gsub_file 'config/database.yml', 'password:', "password: #{password}"

# download views
remove_file "app/views/layouts/application.html.erb"
get "#{repository_url}/app/views/layout/application.html.haml", "app/views/layouts/application.html.haml"
get "#{repository_url}/app/views/layout/_css.html.haml", "app/views/layouts/_css.html.haml"
get "#{repository_url}/app/views/layout/_javascripts.html.haml", "app/views/layouts/_javascripts.html.haml"
gsub_file 'app/views/layouts/application.html.haml', 'APP_NAME', "#{app_name}"

['_header', '_footer', '_navigation', '_tracking', '_pagination', '_pagination_links', '_user'].each do |shared|
  get "#{repository_url}/app/views/shared/#{shared}.html.haml", "app/views/shared/#{shared}.html.haml"
end
gsub_file 'app/views/shared/_header.html.haml', 'APP_NAME', "#{app_name}"
gsub_file 'app/views/shared/_footer.html.haml', 'APP_NAME', "#{app_name}"

['pages/home', 'users/show'].each do |page|
  get "#{repository_url}/app/views/#{page}.html.haml", "app/views/#{page}.html.haml"
end

# download helpers
remove_file "app/helpers/application_helper.rb"
['application', 'layout'].each do |helper|
  get "#{repository_url}/app/helpers/#{helper}_helper.rb", "app/helpers/#{helper}_helper.rb"
end

# download controllers
['pages', 'users'].each do |controller|
  get "#{repository_url}/app/controllers/#{controller}_controller.rb", "app/controllers/#{controller}_controller.rb"
end

# download models
['user'].each do |model|
  get "#{repository_url}/app/models/#{model}.rb", "app/models/#{model}.rb"
end

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

remove_file ".gitignore"
gitignore = <<-GITIGNORE
tmp/[^.]*
log/[^.]*
doc/app
doc/api
.svn
*~
log/*.log
tmp/**/*
tmp/*
.DS\_Store
.DS_Store
db/*.sqlite3
/log/*.pid
/coverage/*
public/system/*
.ackrc
public/assets/[^.]*
public/stylesheets/*.css
*.scssc
config/database.yml
config/mail.yml
config/settings.yml
.bundle
vendor/bundle
capybara*
GITIGNORE

create_file ".gitignore", gitignore

git :init
git :add => "."
git :commit => "-m 'initial commit'"

run("gem install bundler capistrano")
run("bundle install --path vendor/bundle")
run("bundle pack")
git :add => "."
git :commit => "-m 'add the gems'"

run("bundle exec rails generate simple_form:install")
gsub_file 'config/initializers/simple_form.rb', ', :error', ""
git :add => "."
git :commit => "-m 'install simple_form'"

run("bundle exec rake db:create:all")
run("bundle exec rails generate devise:install")
gsub_file 'config/initializers/devise.rb', 'please-change-me@config-initializers-devise.com', "admin@#{app_name}.com"
route("devise_for :users")
inject_into_file "config/environments/test.rb", "  config.action_mailer.default_url_options = { :host => 'local.#{app_name}.com' }\n", :after => "delivery_method = :test\n"
inject_into_file "config/environments/development.rb", "  config.action_mailer.default_url_options = { :host => 'local.#{app_name}.com' }\n", :after => "raise_delivery_errors = false\n"
inject_into_file "config/environments/production.rb", "  config.action_mailer.default_url_options = { :host => '#{app_name}.com' }\n", :after => "raise_delivery_errors = false\n"
git :add => "."
git :commit => "-m 'install devise'"

run("bundle exec rake db:migrate")
run("bundle exec rails generate rspec:install")
git :add => "."
git :commit => "-m 'install rspec'"

get "#{repository_url}/spec/factories.rb", "spec/factories.rb"
git :add => "."
git :commit => "-m 'install factories'"

run("bundle exec rails generate cucumber:install --rspec --capybara")
git :add => "."
git :commit => "-m 'install cucumber'"

['confirmation', 'forgot_password','pages','session','signup'].each do |feature|
  get "#{repository_url}/features/#{feature}.feature", "features/#{feature}.feature"
end
get "#{repository_url}/features/step_definitions/authentication_steps.rb", "features/step_definitions/authentication_steps.rb"
remove_file "features/support/paths.rb"
get "#{repository_url}/features/support/paths.rb", "features/support/paths.rb"
get "#{repository_url}/features/support/db_cleaner.rb", "features/support/db_cleaner.rb"
inject_into_file "features/support/env.rb", "Capybara.ignore_hidden_elements = false\n", :after => "Capybara.default_selector = :css\n"
append_file "features/support/env.rb", "FakeWeb.allow_net_connect = %r[^https?://(localhost|127\.0\.0\.1)]\n"
git :add => "."
git :commit => "-m 'default feature and steps'"

# download deploy scripts
get "#{repository_url}/config/deploy.rb", "config/deploy.rb"
get "#{repository_url}/Capfile", "Capfile"
['callbacks', 'development', 'git', 'maintenance', 'passenger', 'production', 'settings', 'symlinks'].each do |deploy|
  get "#{repository_url}/config/deploy/#{deploy}.rb", "config/deploy/#{deploy}.rb"
end
gsub_file 'config/deploy/settings.rb', 'APP_NAME', "#{app_name}"
git :add => "."
git :commit => "-m 'install deploy scripts'"


docs = <<-DOCS
We just ran
gem install bundler capistrano
bundle install
bundle exec rake db:create:all
bundle exec rails generate devise:install
bundle exec rake db:migrate
bundle exec rails generate rspec:install
bundle exec rails generate cucumber:install --rspec --capybara

Run the following commands to complete the setup of #{app_name.classify}:

cd #{app_name}

Change 'config/initializers/devise.rb' to have the proper email address for your mailer.

DOCS

log docs
