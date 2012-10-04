repository_url = "https://github.com/jgeiger/bootstrap-rails3/raw/master"

# Remove normal files we don't want
%w(README public/index.html public/favicon.ico public/robots.txt app/assets/images/rails.png app/assets/javascripts/application.js app/controllers/application_controller.rb).each do |f|
  remove_file f
end


# Gems, listed in alpha order

gem 'haml'

gem 'bootstrap-sass'
gem 'simple_form'
gem 'bootstrap-datepicker-rails'

gem 'uuidtools'

gem 'omniauth'
gem 'omniauth-google-oauth2'
gem "american_date"

gem_group :development, :test do
  gem "debugger"
  gem "pry"
  gem "faker"
  gem "haml-rails"
  gem 'rspec-rails'
  gem "capybara"
  gem 'database_cleaner'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'fakeweb'
  gem 'rest-client'
  gem 'simplecov'
end

# download images
get "#{repository_url}/app/assets/images/layout/loading.gif", "app/assets/images/layout/loading.gif"
['icons/success', 'icons/warning', 'icons/notice', 'icons/error', 'layout/logo'].each do |img|
  get "#{repository_url}/app/assets/images/#{img}.png", "app/assets/images/#{img}.png"
end

#download javascript
get "https://github.com/malsup/blockui/raw/master/jquery.blockUI.js", "app/assets/javascripts/jquery/jquery.blockUI.js"
get "https://github.com/documentcloud/underscore/raw/master/underscore.js", "app/assets/javascripts/lib/underscore.js"
get "http://modernizr.com/downloads/modernizr-2.6.2.js", "app/assets/javascripts/lib/modernizr.js"
['lib/webfonts', 'main', 'application'].each do |js_file|
  get "#{repository_url}/app/assets/javascripts/#{js_file}.js", "app/assets/javascripts/#{js_file}.js"
end

#download css
remove_file "app/assets/stylesheets/application.css"
get "#{repository_url}/app/assets/stylesheets/application.scss", "app/assets/stylesheets/application.scss"
['_fonts', '_main'].each do |file|
  get "#{repository_url}/app/assets/stylesheets/partials/#{file}.scss", "app/assets/stylesheets/partials/#{file}.scss"
end

# download config
remove_file "config/routes.rb"
remove_file "config/locales/en.yml"
['locales/en.yml', 'routes.rb', 'initializers/generators.rb', 'initializers/omniauth.rb', 'initializers/date_formats.rb'].each do |file|
  get "#{repository_url}/config/#{file}", "config/#{file}"
end

# download migration
['0001_create_users.rb'].each do |file|
  get "#{repository_url}/db/migrate/#{file}", "db/migrate/#{file}"
end

# fix configs
gsub_file 'config/routes.rb', 'APP_NAME', "#{app_name.classify}"
gsub_file 'config/locales/en.yml', 'APP_NAME', "#{app_name}"
username = ask("Local database username (enter for root):")
password = ask("Local database password (enter for blank):")
username = username.blank? ? "root" : username
puts "Setting database username to #{username}"
puts "Setting database password to #{password}"
gsub_file 'config/database.yml', "username: #{app_name}", "username: #{username}"
gsub_file 'config/database.yml', 'password:', "password: #{password}"

# download controllers
['application', 'pages', 'sessions', 'users'].each do |controller|
  get "#{repository_url}/app/controllers/#{controller}_controller.rb", "app/controllers/#{controller}_controller.rb"
end

# download helpers
remove_file "app/helpers/application_helper.rb"
['application'].each do |helper|
  get "#{repository_url}/app/helpers/#{helper}_helper.rb", "app/helpers/#{helper}_helper.rb"
end

# download models
['user'].each do |model|
  get "#{repository_url}/app/models/#{model}.rb", "app/models/#{model}.rb"
end

# download views
remove_file "app/views/layouts/application.html.erb"

['layouts/application', 'pages/home', 'sessions/new', 'users/dashboard'].each do |view_file|
  get "#{repository_url}/app/views/#{view_file}.html.haml", "app/views/#{view_file}.html.haml"
end

['_header', '_footer', '_tracking', '_sign_in_sign_out', '_navigation'].each do |shared|
  get "#{repository_url}/app/views/shared/#{shared}.html.haml", "app/views/shared/#{shared}.html.haml"
end

gsub_file 'app/views/layouts/application.html.haml', 'APP_NAME', "#{app_name}"
gsub_file 'app/views/shared/_header.html.haml', 'APP_NAME', "#{app_name}"
gsub_file 'app/views/shared/_footer.html.haml', 'APP_NAME', "#{app_name}"

# download lib
inside('lib') do
  run "mkdir extras"
end

['extras/simple_form_extensions.rb', 'tasks/postgres.rake'].each do |lib_file|
  get "#{repository_url}/lib/#{lib_file}", "lib/#{lib_file}"
end

gsub_file 'config/application.rb', '# config.autoload_paths += %W(#{config.root}/extras)', "config.autoload_paths += %W(\#{config.root}/lib/extras)"

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

remove_file ".gitignore"
gitignore = <<-GITIGNORE
#----------------------------------------------------------------------------
# Ignore these files when commiting to a git repository.
#
# See http://help.github.com/ignore-files/ for more about ignoring files.
#
# The original version of this file is found here:
# https://github.com/RailsApps/rails3-application-templates/raw/master/files/gitignore.txt
#
# Corrections? Improvements? Create a GitHub issue:
# http://github.com/RailsApps/rails3-application-templates/issues
#----------------------------------------------------------------------------

# bundler state
/.bundle
/vendor/bundle/

# minimal Rails specific artifacts
db/*.sqlite3
/log/*.log
/log/*.pid
/tmp

# various artifacts
**.war
*.rbc
*.sassc
.rspec
.redcar/
.sass-cache
/config/config.yml
/config/database.yml
/config/mail.yml
/coverage.data
/coverage/
/db/*.javadb/
/db/*.sqlite3-journal
/doc/api/
/doc/app/
/doc/features.html
/doc/specs.html
/public/cache
/public/stylesheets/compiled
/public/assets/[^.]*
/public/uploads/[^.]*
/public/stylesheets/*.css
/public/system
/spec/tmp/*
/cache
/capybara*
/capybara-*.html
/gems
/rerun.txt
/specifications
/tags


# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile ~/.gitignore_global
#
# Here are some files you may want to ignore globally:

# scm revert files
**.orig

# Mac finder artifacts
.DS_Store

# Netbeans project directory
/nbproject/

# RubyMine project files
.idea

# Textmate project files
/*.tmproj

# vim artifacts
**.swp
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
run("bundle exec rake db:migrate")
run("bundle exec rake db:test:prepare")
run("bundle exec rails generate rspec:install")
git :add => "."
git :commit => "-m 'install rspec'"

['application', 'pages', 'sessions', 'users'].each do |spec_file|
  get "#{repository_url}/spec/controllers/#{spec_file}_controller_spec.rb", "spec/controllers/#{spec_file}_controller_spec.rb"
end

['factories/users', 'models/user_spec', 'helpers/application_helper_spec', 'views/users/dashboard.haml.html_spec'].each do |spec_file|
  get "#{repository_url}/spec/#{spec_file}.rb", "spec/#{spec_file}.rb"
end

git :add => "."
git :commit => "-m 'install specs'"

run("bundle exec rails generate simple_form:install --bootstrap")

remove_file "config/initializers/simple_form.rb"

['simple_form.rb'].each do |initializer_file|
  get "#{repository_url}/config/initializers/#{initializer_file}", "config/initializers/#{initializer_file}"
end

git :add => "."
git :commit => "-m 'install simple_form'"

docs = <<-DOCS
We just ran
gem install bundler capistrano
bundle install
bundle exec rake db:create:all
bundle exec rake db:migrate
bundle exec rake db:test:prepare
bundle exec rails generate rspec:install
bundle exec rails generate simple_form

Run the following commands to complete the setup of #{app_name.classify}:

cd #{app_name}

DOCS

log docs
