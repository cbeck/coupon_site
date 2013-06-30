set :user, "admin"
set :use_sudo, false

# Replace with your AWS credentials
# set :keypair, "netphase-keypair"
set :keypair, "netphase-keypair"

set :account_id, "267343494221"
set :access_key_id, "1MZTQGBA4YWAFHSTG4R2"
set :secret_access_key, "pzHKZhB4sb/GUNLQFx87Rtrm03aA7s6QK8zHiL+l"
set :pk, "pk-YMC4ZT7XIPO2GR3KMW6FE33RBC4KNCFH.pem"
set :cert, "cert-YMC4ZT7XIPO2GR3KMW6FE33RBC4KNCFH.pem"

# set :username, "root"
# set :keypair_full_path, "#{ENV['HOME']}/.ec2/id_rsa-#{keypair}"

ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false
ssh_options[:username] = user
ssh_options[:compression] = false
# ssh_options[:keys] = keypair_full_path

set :scm, :git
set :repository_cache, "git_cache"
set :git_enable_submodules, true
set :deploy_via, :remote_cache

# default_run_options[:pty] = true

