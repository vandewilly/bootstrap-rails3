repository_url = "http://github.com/jgeiger/bootstrap-rails3/raw/facebook"

# Remove normal files we don't want
%w(README public/index.html public/favicon.ico public/robots.txt public/images/rails.png).each do |f|
  remove_file f
end

# Gems, listed in alpha order

gem 'haml'
gem 'haml-rails', :git => 'http://github.com/indirect/haml-rails.git'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'will_paginate', '3.0.pre2'
gem 'jammit', :git => 'http://github.com/documentcloud/jammit.git'

gem 'omniauth'
gem 'mini_fb'

gem 'simple_form'

gem "capybara", :git => "http://github.com/jnicklas/capybara.git", :group => [:test, :cucumber]
gem 'database_cleaner', :git => "http://github.com/bmabey/database_cleaner.git", :group => [:test, :cucumber]
gem 'cucumber-rails', :group => [:test, :cucumber]
gem 'cucumber', :group => [:test, :cucumber]
gem 'spork', :group => [:test, :cucumber]
gem 'launchy', :group => [:test, :cucumber]    # So you can do Then show me the page
gem 'webrat', :group => [:test, :cucumber]
gem 'rspec', '>= 2.0.0', :group => [:test, :cucumber]
gem 'rspec-rails', '>= 2.0.1', :group => [:development, :test, :cucumber]
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
get "http://github.com/jgeiger/blockui/raw/master/jquery.blockUI.js", "public/javascripts/jquery/jquery.blockUI.js"
get "http://github.com/documentcloud/underscore/raw/master/underscore.js", "public/javascripts/lib/underscore.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/lib/rails.js"

remove_file "public/javascripts/application.js"
get "#{repository_url}/public/javascripts/application.js", "public/javascripts/application.js"

# download css
['reset', 'fonts', 'grids', 'base'].each do |file|
  get "http://yui.yahooapis.com/3.2.0/build/css#{file}/#{file}.css", "public/stylesheets/yui/#{file}.css"
end

['application', '_colors', '_flash_messages', '_fonts', '_forms', '_layout', '_pagination', '_template', '_variables'].each do |file|
  get "#{repository_url}/public/stylesheets/sass/#{file}.scss", "public/stylesheets/sass/#{file}.scss"
end

# download images
get "#{repository_url}/public/images/layout/loading.gif", "public/images/layout/loading.gif"
['icons/success', 'icons/warning', 'icons/notice', 'icons/error', 'layout/logo', 'layout/facebook_64'].each do |img|
  get "#{repository_url}/public/images/#{img}.png", "public/images/#{img}.png"
end

# download config
remove_file "config/routes.rb"
remove_file "config/locales/en.yml"
['assets.yml', 'locales/en.yml', 'routes.rb', 'initializers/omniauth.rb', 'initializers/mail.rb', 'mail.yml'].each do |file|
  get "#{repository_url}/config/#{file}", "config/#{file}"
end
get "#{repository_url}/db/migrate/001_create_users.rb", "db/migrate/001_create_users.rb"
get "#{repository_url}/db/migrate/002_create_authentications.rb", "db/migrate/002_create_authentications.rb"


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
gsub_file 'app/views/layouts/application.html.haml', 'APP_NAME', "#{app_name}"

['_header', '_footer', '_navigation', '_tracking', '_pagination', '_pagination_links', '_user'].each do |shared|
  get "#{repository_url}/app/views/shared/#{shared}.html.haml", "app/views/shared/#{shared}.html.haml"
end
gsub_file 'app/views/shared/_header.html.haml', 'APP_NAME', "#{app_name}"
gsub_file 'app/views/shared/_footer.html.haml', 'APP_NAME', "#{app_name}"

['pages/home', 'users/show', 'sessions/new'].each do |page|
  get "#{repository_url}/app/views/#{page}.html.haml", "app/views/#{page}.html.haml"
end

# download helpers
remove_file "app/helpers/application_helper.rb"
['application', 'pages', 'users', 'layout'].each do |helper|
  get "#{repository_url}/app/helpers/#{helper}_helper.rb", "app/helpers/#{helper}_helper.rb"
end

# download controllers
remove_file "app/controllers/application_controller.rb"
['sessions', 'pages', 'users', 'application'].each do |controller|
  get "#{repository_url}/app/controllers/#{controller}_controller.rb", "app/controllers/#{controller}_controller.rb"
end

# download models
['user', 'authentication'].each do |model|
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

['pages', 'session'].each do |feature|
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
bundle exec rake db:migrate
bundle exec rails generate rspec:install
bundle exec rails generate cucumber:install --rspec --capybara

Run the following commands to complete the setup of #{app_name.classify}:

cd #{app_name}

DOCS

log docs
