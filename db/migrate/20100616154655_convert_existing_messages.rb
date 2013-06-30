class ConvertExistingMessages < ActiveRecord::Migration
  def self.up
    ag = AffiliateGroup.find_by_name("Carolina MoneySaver")
    Contact.update_all("affiliate_group_id = #{ag.id}") if ag
  end

  def self.down
    Contact.update_all("affiliate_group_id = NULL")
  end
end
