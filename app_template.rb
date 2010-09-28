# Remove normal files we don't want
%w(README public/index.html public/favicon.ico public/robots.txt public/images/rails.png).each do |f|
  remove_file f
end

# Gems, listed in alpha order

gem 'haml'
gem 'haml-rails', :git => 'git://github.com/indirect/haml-rails.git'
gem 'warden'
gem 'devise', :git => 'git://github.com/plataformatec/devise.git'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'oauth2'
gem 'will_paginate', '3.0.pre2'
gem 'jammit', '0.5.3'

gem "capybara", :git => "git://github.com/jnicklas/capybara.git", :group => [:test, :cucumber]
gem 'database_cleaner', :git => "git://github.com/bmabey/database_cleaner.git", :group => [:test, :cucumber]
gem 'cucumber-rails', :group => [:test, :cucumber]
gem 'cucumber', :group => [:test, :cucumber]
gem 'spork', :group => [:test, :cucumber]
gem 'launchy', :group => [:test, :cucumber]    # So you can do Then show me the page
gem 'webrat', :group => [:test, :cucumber]
gem 'rspec', '>= 2.0.0.beta.22', :group => [:test, :cucumber]
gem 'rspec-rails', '>= 2.0.0.beta.22', :group => [:development, :test, :cucumber]
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
get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.js",  "public/javascripts/jquery/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jquery-ui.js", "public/javascripts/jquery/jquery-ui.js"
get "http://github.com/jgeiger/blockui/raw/master/jquery.blockUI.js", "public/javascripts/jquery/jquery.blockUI.js"
get "http://github.com/documentcloud/underscore/raw/master/underscore.js", "public/javascripts/lib/underscore.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/lib/rails.js"

remove_file "public/javascripts/application.js"
get "http://github.com/jgeiger/rails3-app/raw/master/public/javascripts/application.js", "public/javascripts/application.js"

# download css
['reset', 'fonts', 'grids', 'base'].each do |file|
  get "http://yui.yahooapis.com/3.2.0/build/css#{file}/#{file}.css", "public/stylesheets/yui/#{file}.css"
end

['application', '_pagination', '_flash_messages', '_variables', '_fonts', '_layout'].each do |file|
  get "http://github.com/jgeiger/rails3-app/raw/master/public/stylesheets/sass/#{file}.scss", "public/stylesheets/sass/#{file}.scss"
end

# download images
get "http://github.com/jgeiger/rails3-app/raw/master/public/images/loading.gif", "public/images/layout/loading.gif"
['success', 'warning', 'notice', 'error'].each do |img|
  get "http://github.com/jgeiger/rails3-app/raw/master/public/images/#{img}.png", "public/images/icons/#{img}.png"
end

# download config
remove_file "config/routes.rb"
remove_file "config/locales/en.yml"
['assets.yml', 'locales/en.yml', 'routes.rb', 'initializers/mail.rb', 'mail.yml'].each do |file|
  get "http://github.com/jgeiger/rails3-app/raw/master/config/#{file}", "config/#{file}"
end
get "http://github.com/jgeiger/rails3-app/raw/master/db/migrate/001_devise_create_users.rb", "db/migrate/001_devise_create_users.rb"


# fix configs
gsub_file 'config/routes.rb', 'APP_NAME', "#{app_name.humanize}"
gsub_file 'config/locales/en.yml', 'APP_NAME', "#{app_name}"
gsub_file 'config/database.yml', 'password:', "password: root"

# download views
remove_file "app/views/layouts/application.html.erb"
get "http://github.com/jgeiger/rails3-app/raw/master/app/views/layout/application.html.haml", "app/views/layouts/application.html.haml"
gsub_file 'app/views/layouts/application.html.haml', 'APP_NAME', "#{app_name}"

['_header', '_footer', '_navigation', '_tracking', '_pagination', '_pagination_links', '_user'].each do |shared|
  get "http://github.com/jgeiger/rails3-app/raw/master/app/views/shared/#{shared}.html.haml", "app/views/shared/#{shared}.html.haml"
end
gsub_file 'app/views/shared/_header.html.haml', 'APP_NAME', "#{app_name}"
gsub_file 'app/views/shared/_footer.html.haml', 'APP_NAME', "#{app_name}"

['pages/home', 'users/show'].each do |page|
  get "http://github.com/jgeiger/rails3-app/raw/master/app/views/#{page}.html.haml", "app/views/#{page}.html.haml"
end

# download devise views
['confirmations/new', 'mailer/confirmation_instructions', 'mailer/reset_password_instructions', 'mailer/unlock_instructions',
 'passwords/edit', 'passwords/new', 'registrations/edit', 'registrations/new', 'sessions/new', 'shared/_links', 'unlocks/new'].each do |devise|
   get "http://github.com/jgeiger/rails3-app/raw/master/app/views/devise/#{devise}.html.haml", "app/views/devise/#{devise}.html.haml"
end
gsub_file 'app/views/devise/mailer/confirmation_instructions.html.haml', 'APP_NAME', "#{app_name}"

# download helpers
remove_file "app/helpers/application_helper.rb"
['application', 'pages', 'users', 'layout'].each do |helper|
  get "http://github.com/jgeiger/rails3-app/raw/master/app/helpers/#{helper}_helper.rb", "app/helpers/#{helper}_helper.rb"
end

# download controllers
['pages', 'users'].each do |controller|
  get "http://github.com/jgeiger/rails3-app/raw/master/app/controllers/#{controller}_controller.rb", "app/controllers/#{controller}_controller.rb"
end

# download models
['user'].each do |model|
  get "http://github.com/jgeiger/rails3-app/raw/master/app/models/#{model}.rb", "app/models/#{model}.rb"
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

run("gem install bundler capistrano watchr")
run("bundle install --path vendor/bundle")
run("bundle pack")
git :add => "."
git :commit => "-m 'add the gems'"

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

get "http://github.com/jgeiger/rails3-app/raw/master/spec/factories.rb", "spec/factories.rb"
git :add => "."
git :commit => "-m 'install factories'"


run("bundle exec rails generate cucumber:install --rspec --capybara")
git :add => "."
git :commit => "-m 'install cucumber'"

['confirmation', 'forgot_password','pages','session','signup'].each do |feature|
  get "http://github.com/jgeiger/rails3-app/raw/master/features/#{feature}.feature", "features/#{feature}.feature"
end
get "http://github.com/jgeiger/rails3-app/raw/master/features/step_definitions/authentication_steps.rb", "features/step_definitions/authentication_steps.rb"
remove_file "features/support/paths.rb"
get "http://github.com/jgeiger/rails3-app/raw/master/features/support/paths.rb", "features/support/paths.rb"
get "http://github.com/jgeiger/rails3-app/raw/master/features/support/db_cleaner.rb", "features/support/db_cleaner.rb"
inject_into_file "features/support/env.rb", "Capybara.ignore_hidden_elements = false\n", :after => "Capybara.default_selector = :css\n"
append_file "features/support/env.rb", "FakeWeb.allow_net_connect = %r[^https?://(localhost|127\.0\.0\.1)]\n"
git :add => "."
git :commit => "-m 'default feature and steps'"

get "http://github.com/jgeiger/rails3-app/raw/master/app.watchr", "app.watchr"
git :add => "."
git :commit => "-m 'watchr script'"

# download deploy scripts
get "http://github.com/jgeiger/rails3-app/raw/master/config/deploy.rb", "config/deploy.rb"
get "http://github.com/jgeiger/rails3-app/raw/master/Capfile", "Capfile"
['callbacks', 'development', 'git', 'maintenance', 'passenger', 'production', 'settings', 'symlinks'].each do |deploy|
  get "http://github.com/jgeiger/rails3-app/raw/master/config/deploy/#{deploy}.rb", "config/deploy/#{deploy}.rb"
end
gsub_file 'config/deploy/settings.rb', 'APP_NAME', "#{app_name}"
git :add => "."
git :commit => "-m 'install deploy scripts'"


docs = <<-DOCS
We just ran
gem install bundler capistrano watchr
bundle install
bundle exec rake db:create:all
bundle exec rails generate devise:install
bundle exec rake db:migrate
bundle exec rails generate rspec:install
bundle exec rails generate cucumber:install --rspec --capybara

Run the following commands to complete the setup of #{app_name.humanize}:

cd #{app_name}

Change 'config/initializers/devise.rb' to have the proper email address for your mailer.

DOCS

log docs
