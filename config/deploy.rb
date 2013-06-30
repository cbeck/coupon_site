set :application, "moneysaver"
set :deploy_to, "/vol/apps/#{application}"
set :repository, "git@github.com:netphase/moneysaver.git"
set :rails_env, 'production'

# set :image_id, "ami-bded09d4"

# Set the instance id after calling 'cap instance:start'
# set :instance_id, "i-8cce6ae5"

# Set the instance url, which can be found by calling 'ec2-describe-instances'
# after the instance has booted
# set :instance_url, "ec2-75-101-193-229.compute-1.amazonaws.com"

set :domain, "moneysaver.netphase.com"

set :disable_template, "./app/views/site/maintenance_youtube.html.erb"

server domain, :app, :web, :db, :primary => true

desc "Setup my symlinks"
task :after_update_code, :roles => [:web] do
  run <<-EOF
    # ln -s #{shared_path}/system/site_keys.rb #{latest_release}/config/initializers/
    # ln -s #{shared_path}/system/.htaccess #{latest_release}/public/
  EOF
  # doesn't seem to like to do in the EOF statement...
  run "ln -nfs #{shared_path}/uploads/images #{latest_release}/public/uploaded_images"
end

# example call:
# UNTIL="16:00 MST" REASON="a database upgrade" cap disable_web
desc "Generate a maintenance.html to disable requests to the application."
deploy.web.task :disable, :roles => :web do
  remote_path = "#{shared_path}/system/maintenance.html"
  on_rollback { run "rm #{remote_path}" }
  template = File.read(disable_template)
  deadline, reason = ENV["UNTIL"], ENV["REASON"]
  maintenance = ERB.new(template).result(binding)
  put maintenance, "#{remote_path}", :mode => 0644
end

desc "Re-enable the web server by deleting any maintenance file."
deploy.web.task :enable, :roles => :web do
  run "rm #{shared_path}/system/maintenance.html"
end

after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end

# http://github.com/jamis/capistrano/blob/master/lib/capistrano/recipes/deploy.rb
# :default -> update, restart
# :update  -> update_code, symlink
namespace :deploy do
  task :before_update do
    # Stop Thinking Sphinx before the update so it finds its configuration file.
    thinking_sphinx.stop
  end

  task :after_update do
    symlink_sphinx_indexes
    thinking_sphinx.configure
    thinking_sphinx.start
  end

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end
end
