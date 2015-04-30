lock '3.4.0'

require 'capistrano-db-tasks'
set :scm, :git
set :git_strategy, SubmoduleStrategy
set :git_enable_submodules, 1
# set :format, :pretty
# set :log_level, :debug
# set :pty, true
set :keep_releases, 5

set :linked_files, %w{config/database.yml config/secrets.yml config/env} 
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'

set :bundle_without, %w{development test deploy}.join(' ')

#set :honeybadger_async_notify, true
#set :honeybadger_deploy_task, 'honeybadger:deploy_with_environment'

# if you want to remove the local dump file after loading
set :db_local_clean, true
# if you want to remove the dump file from the server after downloading
set :db_remote_clean, false

# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w{public/uploads}
set :local_assets_dir, "public"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do |server|
      execute "/etc/init.d/unicorn-#{fetch(:application)} upgrade"
    end
  end


  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :publishing, :restart
  after :finishing, 'deploy:cleanup'

end
