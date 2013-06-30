class CreateSingleAffiliateGroups < ActiveRecord::Migration
  def self.up
    affiliates = Affiliate.all
    affiliates.each {|affiliate|
      group = AffiliateGroup.create :name => affiliate.name, :description => affiliate.description
      membership = AffiliateGroupMembership.create :affiliate_id => affiliate.id, :affiliate_group_id => group.id, :active => true
    }
  end

  def self.down
    affiliates = Affiliate.all
    affiliates.each {|affiliate|
      group = AffiliateGroup.find_by_name affiliate.name
      group.destroy
    }
  end
end
