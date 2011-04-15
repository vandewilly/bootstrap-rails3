namespace :deploy do

  desc "expand the gems"
  task :gems, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; bundle install --gemfile Gemfile --deployment --without cucumber development test"
  end

  desc 'Compile, bundle and minify the JS and CSS files'
  task :precache_assets, :roles => :app do
    root_path = File.expand_path(File.dirname(__FILE__) + '/../..')
    sass_path = "#{root_path}/public/stylesheets/sass/"
    css_path = "#{root_path}/public/stylesheets/"
    run_locally "bundle exec #{root_path}/vendor/bundle/ruby/1.9.1/bin/sass --update #{sass_path}:#{css_path}"
    assets_path = "#{root_path}/public/assets"
    run_locally "bundle exec #{root_path}/vendor/bundle/ruby/1.9.1/bin/jammit"
    top.upload assets_path, "#{current_path}/public", :via => :scp, :recursive => true
  end

end
