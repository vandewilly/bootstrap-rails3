repository_url = "https://github.com/jgeiger/bootstrap-rails3/raw/noauth"

# Remove normal files we don't want
%w(README public/index.html public/favicon.ico public/robots.txt app/assets/images/rails.png).each do |f|
  remove_file f
end

# Gems, listed in alpha order

gem 'haml'

gem 'kaminari'
gem 'simple_form'
gem "zurb-foundation"

gem 'uuidtools'
gem 'capistrano'
gem 'capistrano-ext'

gem 'omniauth'
gem 'omniauth-google-oauth2'

gem "debugger", :group => [:test, :development]
gem "pry", :group => [:test, :development]
gem "faker", :group => [:test, :development]
gem "haml-rails", :group => [:test, :development]
gem 'rspec-rails', :group => [:development, :test]
gem 'cucumber-rails', :group => [:development, :test]
gem "capybara", :group => [:test, :development]
gem 'database_cleaner', :group => [:test, :development]
gem 'launchy', :group => [:test, :development]    # So you can do Then show me the page
gem 'factory_girl_rails', :group => [:test, :development]
gem 'fakeweb', :group => [:test, :development]
gem 'rest-client', :group => [:test, :development]
gem 'simplecov', :group => [:test, :development]

generators = <<-GENERATORS

  config.generators do |g|
    g.template_engine :haml
    g.test_framework :rspec, :fixture => true, :views => false
  end
GENERATORS

application generators

#download javascript
get "https://github.com/malsup/blockui/raw/master/jquery.blockUI.js", "app/assets/javascripts/jquery/jquery.blockUI.js"
get "https://github.com/documentcloud/underscore/raw/master/underscore.js", "app/assets/javascripts/lib/underscore.js"
get "https://github.com/nathansmith/formalize/raw/master/assets/js/jquery.formalize.js", "app/assets/javascripts/jquery/jquery.formalize.js"
get "http://modernizr.com/downloads/modernizr-2.5.3.js", "app/assets/javascripts/lib/modernizr.js"
get "#{repository_url}/app/assets/javascripts/lib/webfonts.js", "app/assets/javascripts/lib/webfonts.js"

get "#{repository_url}/app/assets/javascripts/main.js", "app/assets/javascripts/main.js"

remove_file "app/assets/stylesheets/application.css"
get "#{repository_url}/app/assets/stylesheets/application.css.scss", "app/assets/stylesheets/application.css.scss"
['_flash_messages', '_fonts', '_forms', '_formalize', '_grid', '_layout', '_template', '_pagination', '_variables'].each do |file|
  get "#{repository_url}/app/assets/stylesheets/partials/#{file}.css.scss", "app/assets/stylesheets/partials/#{file}.css.scss"
end

# download images
get "https://github.com/nathansmith/formalize/blob/master/assets/images/button.png", "app/assets/images/layout/button.png"
get "https://github.com/nathansmith/formalize/blob/master/assets/images/select_arrow.gif", "app/assets/images/layout/select_arrow.gif"
get "#{repository_url}/app/assets/images/layout/loading.gif", "app/assets/images/layout/loading.gif"
['icons/success', 'icons/warning', 'icons/notice', 'icons/error', 'layout/logo'].each do |img|
  get "#{repository_url}/app/assets/images/#{img}.png", "app/assets/images/#{img}.png"
end

# download config
remove_file "config/routes.rb"
remove_file "config/locales/en.yml"
['locales/en.yml', 'routes.rb', 'initializers/mail.rb', 'mail.yml'].each do |file|
  get "#{repository_url}/config/#{file}", "config/#{file}"
end


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

['_header', '_footer', '_navigation', '_tracking', '_pagination', '_pagination_links'].each do |shared|
  get "#{repository_url}/app/views/shared/#{shared}.html.haml", "app/views/shared/#{shared}.html.haml"
end
gsub_file 'app/views/shared/_header.html.haml', 'APP_NAME', "#{app_name}"
gsub_file 'app/views/shared/_footer.html.haml', 'APP_NAME', "#{app_name}"

['pages/home'].each do |page|
  get "#{repository_url}/app/views/#{page}.html.haml", "app/views/#{page}.html.haml"
end

# download helpers
remove_file "app/helpers/application_helper.rb"
['application', 'layout'].each do |helper|
  get "#{repository_url}/app/helpers/#{helper}_helper.rb", "app/helpers/#{helper}_helper.rb"
end

# download controllers
['pages'].each do |controller|
  get "#{repository_url}/app/controllers/#{controller}_controller.rb", "app/controllers/#{controller}_controller.rb"
end

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

# download deploy scripts
get "#{repository_url}/config/deploy.rb", "config/deploy.rb"
get "#{repository_url}/Capfile", "Capfile"
['callbacks', 'development', 'git', 'passenger', 'production', 'settings', 'symlinks'].each do |deploy|
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
