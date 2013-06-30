class BootstrapAffiliateGroupUserMemberships < ActiveRecord::Migration
  def self.up
    users = User.all
    ag = AffiliateGroup.find_by_name("Carolina MoneySaver")
    
    users.each do |user|
      AffiliateGroupUserMembership.create :affiliate_group_id => ag.id, :user_id => user.id
    end
    
  end

  def self.down
    AffiliateGroupUserMembership.delete_all
  end
end
