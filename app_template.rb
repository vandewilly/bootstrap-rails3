# Remove normal files we don't want
%w(README public/index.html public/favicon.ico public/robots.txt public/images/rails.png).each do |f|
  remove_file f
end

# Gems, listed in alpha order

gem 'haml'
gem 'haml-rails', '>= 0.0.2'
gem 'warden'
gem 'devise', :git => 'git://github.com/plataformatec/devise.git', :branch => 'v1.1'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'oauth2'
gem 'will_paginate', '3.0.pre2'
gem 'jammit', :git => "http://github.com/documentcloud/jammit.git"
gem 'admin_data'

gem 'capybara', :group => [:test, :cucumber]
gem 'database_cleaner', :group => [:test, :cucumber]
gem 'cucumber-rails', :group => [:test, :cucumber]
gem 'cucumber', :group => [:test, :cucumber]
gem 'spork', :group => [:test, :cucumber]
gem 'launchy', :group => [:test, :cucumber]    # So you can do Then show me the page
gem 'webrat', :group => [:test, :cucumber]
gem 'rspec', '>= 2.0.0.beta.20', :group => [:test, :cucumber]
gem 'rspec-rails', '>= 2.0.0.beta.20', :group => [:development, :test, :cucumber]

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
get "http://yuiblog.com/sandbox/yui/3.2.0pr1/build/cssreset/reset.css", "public/stylesheets/yui/reset.css"
get "http://yuiblog.com/sandbox/yui/3.2.0pr1/build/cssfonts/fonts.css", "public/stylesheets/yui/fonts.css"
get "http://yuiblog.com/sandbox/yui/3.2.0pr1/build/cssgrids/grids.css", "public/stylesheets/yui/grids.css"
get "http://yuiblog.com/sandbox/yui/3.2.0pr1/build/cssbase/base.css", "public/stylesheets/yui/base.css"

get "http://github.com/jgeiger/rails3-app/raw/master/public/stylesheets/application.css", "public/stylesheets/application.css"

# download images
get "http://github.com/jgeiger/rails3-app/raw/master/public/images/loading.gif", "public/images/layout/loading.gif"
['success', 'warning', 'notice', 'error'].each do |img|
  get "http://github.com/jgeiger/rails3-app/raw/master/public/images/#{img}.png", "public/images/icons/#{img}.png"
end

# download config
remove_file "config/routes.rb"
remove_file "config/locales/en.yml"
get "http://github.com/jgeiger/rails3-app/raw/master/config/assets.yml", "config/assets.yml"
get "http://github.com/jgeiger/rails3-app/raw/master/config/locales/en.yml", "config/locales/en.yml"
get "http://github.com/jgeiger/rails3-app/raw/master/config/routes.rb", "config/routes.rb"
get "http://github.com/jgeiger/rails3-app/raw/master/db/migrate/001_devise_create_users.rb", "db/migrate/001_devise_create_users.rb"

get "http://github.com/jgeiger/rails3-app/raw/master/config/initializers/mail.rb", "config/initializers/mail.rb"
get "http://github.com/jgeiger/rails3-app/raw/master/config/mail.yml", "config/mail.yml"


# fix configs
gsub_file 'config/routes.rb', 'APP_NAME', "#{app_name.humanize}"
gsub_file 'config/locales/en.yml', 'APP_NAME', "#{app_name}"
gsub_file 'config/database.yml', 'password:', "password: root"

# download views
remove_file "app/views/layouts/application.html.erb"
get "http://github.com/jgeiger/rails3-app/raw/master/app/views/layout/application.html.haml", "app/views/layouts/application.html.haml"
gsub_file 'app/views/layouts/application.html.haml', 'APP_NAME', "#{app_name}"

['_header', '_footer', '_navigation', '_tracking', '_rounded_box', '_pagination', '_pagination_links', '_user'].each do |shared|
  get "http://github.com/jgeiger/rails3-app/raw/master/app/views/shared/#{shared}.html.haml", "app/views/shared/#{shared}.html.haml"
end
gsub_file 'app/views/shared/_header.html.haml', 'APP_NAME', "#{app_name}"
gsub_file 'app/views/shared/_footer.html.haml', 'APP_NAME', "#{app_name}"

get "http://github.com/jgeiger/rails3-app/raw/master/app/views/pages/home.html.haml", "app/views/pages/home.html.haml"
get "http://github.com/jgeiger/rails3-app/raw/master/app/views/users/show.html.haml", "app/views/users/show.html.haml"

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
config/database.yml
config/mail.yml
config/settings.yml
.bundle
vendor/bundle
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

run("bundle exec rake db:create:all")
run("bundle exec rails generate devise:install")
gsub_file 'config/initializers/devise.rb', 'please-change-me@config-initializers-devise.com', "admin@#{app_name}.com"
route("devise_for :users")
inject_into_file "config/environments/development.rb", "config.action_mailer.default_url_options = { :host => 'local.#{app_name}.com' }", :after => "raise_delivery_errors = false\n"
inject_into_file "config/environments/production.rb", "config.action_mailer.default_url_options = { :host => '#{app_name}.com' }", :after => "raise_delivery_errors = false\n"
git :add => "."
git :commit => "-m 'install devise'"

run("bundle exec rake db:migrate")
run("bundle exec rails generate rspec:install")
git :add => "."
git :commit => "-m 'install rspec'"

run("bundle exec rails generate cucumber:install --rspec --webrat")
git :add => "."
git :commit => "-m 'install cucumber'"

# download deploy scripts
get "http://github.com/jgeiger/rails3-app/raw/master/config/deploy.rb", "config/deploy.rb"
get "http://github.com/jgeiger/rails3-app/raw/master/Capfile", "Capfile"
['callback', 'development', 'git', 'maintenance', 'passenger', 'production', 'settings', 'symlinks'].each do |deploy|
  get "http://github.com/jgeiger/rails3-app/raw/master/config/deploy/#{deploy}.rb", "config/deploy/#{deploy}.rb"
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
bundle exec rails generate cucumber:install --rspec --webrat

Run the following commands to complete the setup of #{app_name.humanize}:

cd #{app_name}

Change 'config/initializers/devise.rb' to have the proper email address for your mailer.

DOCS

log docs
