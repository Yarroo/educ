# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, 'app'
set :repo_url, 'git@github.com:Yarroo/educ.git'  # Edit this to match your repository
set :branch, :master
set :deploy_to, '/home/deployer/app'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets tmp/persisted vendor/bundle public/system public/uploads }
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.6.5'  # Edit this to match ruby version you use

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

namespace :puma do
  Rake::Task[:restart].clear_actions

  desc "Overwritten puma:restart task"
  task :restart do
    puts "Overwriting puma:restart to ensure that puma is running. Effectively, we are just starting Puma."
    puts "A solution to this should be found."
    invoke 'puma:stop'
    invoke 'puma:start'
  end
end