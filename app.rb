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

gem 'mysql2'
gem 'haml'
gem 'haml-rails', '>= 0.0.2'
gem 'warden'
gem 'devise', :git => 'git://github.com/plataformatec/devise.git'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'oauth2'
gem 'will_paginate', '3.0.pre2'
gem "jammit"
gem 'admin_data'

gem 'capybara', :group => [:test, :cucumber]
gem 'database_cleaner', :group => [:test, :cucumber]
gem 'cucumber-rails', :group => [:test, :cucumber]
gem 'cucumber', :group => [:test, :cucumber]
gem 'spork', :group => [:test, :cucumber]
gem 'launchy', :group => [:test, :cucumber]    # So you can do Then show me the page
gem 'webrat', :group => [:test, :cucumber]
gem 'rspec', '>= 2.0.0.beta.19', :group => [:test, :cucumber]
gem 'rspec-rails', '>= 2.0.0.beta.19', :group => [:development, :test, :cucumber]

generators = <<-GENERATORS
  config.generators do |g|
    g.template_engine :haml
    g.test_framework :rspec, :fixture => true, :views => false
  end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jquery-ui.min.js", "public/javascripts/jquery/jquery-ui.js"
get "http://github.com/jgeiger/blockui/raw/master/jquery.blockUI.js", "public/javascripts/jquery/jquery.blockUI.js"
get "http://github.com/documentcloud/underscore/raw/master/underscore.js", "public/javascripts/lib/underscore.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/lib/rails.js"

get "http://yui.yahooapis.com/combo?3.1.1/build/cssreset/reset-min.css&3.1.1/build/cssfonts/fonts-min.css&3.1.1/build/cssgrids/grids-min.css", "public/stylesheets/reset-fonts-grids.css"
get "http://yui.yahooapis.com/3.1.1/build/cssbase/base-min.css", "public/stylesheets/base.css"

jammit = <<-JAMMIT
embed_assets: on
javascript_compressor: closure # (yui, closure)

javascripts:
  common:
    - public/javascripts/jquery/jquery.js
    - public/javascripts/jquery/jquery-ui.js
    - public/javascripts/jquery/jquery.blockUI.js
    - public/javascripts/lib/underscore.js
    - public/javascripts/lib/rails.js
    - public/javascripts/application.js
  admin:
stylesheets:
  common:
    - public/stylesheets/reset-fonts-grids.css
    - public/stylesheets/base.css
    - public/stylesheets/application.css
  admin:
JAMMIT

create_file "public/stylesheets/application.css", ""

create_file "config/assets.yml", jammit

# Layout
# need way to inject the jammit includes into the layout
# <%= stylesheet_link_tag :commmon, 'screen', :cache => true %>

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
config/database.yml
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
% bundle install (or 'bundle install $BUNDLER_PATH' if RVM/Passenger)
% rails generate rspec:install
% rails generate cucumber:install --rspec --capybara
% rails generate devise:install
% rails generate devise User

DOCS

log docs
