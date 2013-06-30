class AddAdminToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
        t.boolean :admin
    end
    user = User.create(:login => "ms_admin", :name => "Admin", 
        :email => "info@netphase.com", :password => "ms_test", :password_confirmation => "ms_test")
    user.update_attribute :admin, true
    user.register!
    user.activate!
  end

  def self.down
    change_table :users do |t|
      t.remove :admin
    end
    user = User.find_by_login("ms_admin")
    user.destroy
  end
end
