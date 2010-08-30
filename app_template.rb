# Remove normal files we don't want
%w(README public/index.html public/favicon.ico public/robots.txt public/images/rails.png).each do |f|
  remove_file f
end

rvmrc = <<-RVMRC
rvm_gemset_create_on_use_flag=1
rvm gemset use #{app_name}
RVMRC

create_file ".rvmrc", rvmrc

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

gsub_file 'Gemfile', 'mysql', 'mysql2'

generators = <<-GENERATORS

  config.generators do |g|
    g.template_engine :haml
    g.test_framework :rspec, :fixture => true, :views => false
  end
GENERATORS

application generators

#download javascript
get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jquery-ui.min.js", "public/javascripts/jquery/jquery-ui.js"
get "http://github.com/jgeiger/blockui/raw/master/jquery.blockUI.js", "public/javascripts/jquery/jquery.blockUI.js"
get "http://github.com/documentcloud/underscore/raw/master/underscore.js", "public/javascripts/lib/underscore.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/lib/rails.js"

# download css
get "http://yui.yahooapis.com/combo?3.1.1/build/cssreset/reset-min.css&3.1.1/build/cssfonts/fonts-min.css&3.1.1/build/cssgrids/grids-min.css", "public/stylesheets/reset-fonts-grids.css"
get "http://yui.yahooapis.com/3.1.1/build/cssbase/base-min.css", "public/stylesheets/base.css"
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
gsub_file 'config/routes.rb', 'APP_NAME', "#{app_name}.camelcase"
gsub_file 'config/locales/en.yml', 'APP_NAME', "#{app_name}"
gsub_file 'config/database.yml', 'adapter: mysql', "adapter: mysql2"
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

# fix routes

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

docs = <<-DOCS

Run the following commands to complete the setup of #{app_name.humanize}:

% cd #{app_name}
% gem install bundler
% bundle install
% bundle exec rake db:create:all
% bundle exec rails generate devise:install
% bundle exec rake db:migrate
% bundle exec rails generate rspec:install
% bundle exec rails generate cucumber:install --rspec --capybara

DOCS

log docs
