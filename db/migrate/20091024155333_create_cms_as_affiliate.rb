class CreateCmsAsAffiliate < ActiveRecord::Migration
  def self.up
    cms = Affiliate.create :name=>"Carolina MoneySaver", :internal_identifier => "CMS", :billable => false, :description => "Default affiliate"
    
    Account.update_all "affiliate_id = #{cms.id}"
  end

  def self.down
    cms = Affiliate.find_by_name("Carolina MoneySaver")
    cms.destroy
  end
end
