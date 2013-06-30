# namespace :instance do
#   desc "Start an instance"
#   task :start do
#     system "ec2-run-instances #{image_id} -k #{keypair}"
#   end
#   
#   desc "Stop running instance"
#   task :stop do
#     system "ec2-terminate-instances #{instance_id}"
#   end
#   
#   desc "SSH to running instance"
#   task :ssh do
#     system "ssh -i #{keypair_full_path} #{user}@#{instance_url}"
#   end
# 
#   desc "Install and configure apache2 and passenger"
#   task :bootstrap do
#     run <<-CMD
# apt-get install libxml2-dev -y &&
# apt-get install apache2 -y &&
# apt-get install apache2-prefork-dev -y &&
# gem install passenger --no-ri --no-rdoc &&
# cd /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3 &&
# rake clean apache2 &&
# echo "#phusion passenger" >> /etc/apache2/apache2.conf &&
# echo "LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3/ext/apache2/mod_passenger.so" >> /etc/apache2/apache2.conf &&
# echo "PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3" >> /etc/apache2/apache2.conf &&
# echo "PassengerRuby /usr/bin/ruby1.8" >> apache2.conf &&
# /etc/init.d/apache2 restart
#     CMD
#   end
# end