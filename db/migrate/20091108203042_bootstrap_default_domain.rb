class BootstrapDefaultDomain < ActiveRecord::Migration
  def self.up
    affiliate_group = AffiliateGroup.find_by_name("Carolina Moneysaver")
    Domain.create :url => "carolinacoupons.com", :theme_name => "carolina", :affiliate_group_id => affiliate_group.id
  end

  def self.down
    domain = Domain.find_by_url("carolinacoupons.com")
    domain.destroy
  end
end
