#############################################################
#  Application
#############################################################

set :application, 'APP_NAME'
set :deploy_to, "/www/servers/#{application}"

#############################################################
#  Git
#############################################################

set :scm, :git
set :repository,  "git@github.com:USERNAME/#{application}.git"

#############################################################
#  Servers
#############################################################

set :user, 'USERNAME'

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false
set :ssh_options, {:forward_agent => true}
set :stages, %w(development production)
set :default_stage, "development"

#############################################################
#  Includes
#############################################################

require 'capistrano/ext/multistage'

#############################################################
#  Post Deploy Hooks
#############################################################

after  "deploy:update_code", "deploy:write_revision"
before "deploy:gems", "deploy:symlink"
after  "deploy:update_code", "deploy:gems"
after 'deploy:update_code', 'deploy:precache_assets'
