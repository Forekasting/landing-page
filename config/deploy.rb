require 'json'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
 require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'beta.forekast.com'
set :deploy_to, '/srv/www/forekast-landing-page'
set :repository, 'git@github.com:Forekasting/landing-page.git'
set :branch, 'master'

set :pid_file, "#{deploy_to}/shared/tmp/pids/server.pid"
set :state_file, "#{deploy_to}/shared/tmp/sockets/puma.state"
set :ctrl_socket, "unix://#{deploy_to}/shared/tmp/sockets/pumactl.sock"

set :app_port, '4000'
set :app_path, lambda { "#{deploy_to}/#{current_path}" }

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, []

# Optional settings:
set :user, 'root'    # Username in the server to SSH to.
set :ssh_options, '-A'  # ensure that ssh agent forwarding is being used.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
@keys = {}
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
end

set :rvm_path, "/usr/local/rvm/scripts/rvm"

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do

  queue! %[mkdir -p "#{deploy_to}/shared"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared"]

  queue! %[mkdir -p "#{deploy_to}/shared/public"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public"]

end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

