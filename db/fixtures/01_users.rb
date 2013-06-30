# Populate user-related tables with default data

u = User.new :login => 'demo_admin', :email => 'demo_admin@netphase.com', :name => 'Demo Admin',
  :password => 'msdemo', :password_confirmation => 'msdemo', :zip => '28277'
u.register!
u.activate!
u.admin = true
u.save

@@demo_admin = u

u = User.new :login => 'demo_user', :email => 'demo_user@netphase.com', :name => 'Demo User',
  :password => 'msdemo', :password_confirmation => 'msdemo', :zip => '28277'
u.register!
u.activate!
u.save

@@demo_user = u
