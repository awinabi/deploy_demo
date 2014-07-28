# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'deploy_demo'
set :repo_url, 'git@github.com:awinabi/deploy_demo.git'
set :branch, 'master'
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/apps/deploy_demo'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :rails_env, 'production'
set :port, '8080'
set :unicorn_pid, "/var/www/apps/deploy_demo/shared/pids/unicorn.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb"

set :keep_releases, 10

namespace :deploy do

  task :start do
    on roles(:app) do
      puts "cd #{current_path} && bundle exec unicorn -p 8080 -c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)} -D"
    end
  end

  task :stop do
    on roles(:app) do
      run "#{try_sudo} kill `cat #{fetch(:unicorn_pid)}`"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
