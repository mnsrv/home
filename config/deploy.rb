# config valid only for current version of Capistrano
lock "3.8.1"

# Change these
server '188.226.213.93', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:mnsrv/home.git'
set :application,     'home'
set :user,            'sasha'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, %w{config/secrets.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'Updates shared/config/*.yml files with the proper ones for environment'
  task :upload_shared_config_files do
    config_files = {}

    run_locally do
      # Order matters!
      local_config_directories = [
          "config"
      ]

      # Environment specific files first
      local_config_directories.each do |directory|
        Dir.chdir(directory) do
          Dir.glob("*.yml") do |file_name|
            # Skip this file if we've already uploaded a env. specific one
            next if config_files.keys.include? file_name

            cksum = capture "cksum", File.join(Dir.pwd, file_name)
            config_files[file_name] = cksum
          end
        end
      end
    end

    on roles(:all) do
      config_path = File.join shared_path, "config"
      execute "mkdir -p #{config_path}"

      config_files.each do |file_name, local_cksum|
        remote_file_name = "#{config_path}/#{file_name}"

        # Get the
        lsum, lsize, lpath = local_cksum.split

        if test("[ -f #{remote_file_name} ]")
          remote_cksum = capture "cksum", remote_file_name
          rsum, rsize, rpath = remote_cksum.split

          if lsum != rsum
            upload! lpath, remote_file_name
            info "Replaced #{file_name} -> #{remote_file_name}"
          end
        else
          upload! lpath, remote_file_name
          info "Upload new #{file_name} -> #{remote_file_name}"
        end
      end
    end
  end

  before :check, :upload_shared_config_files
  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
