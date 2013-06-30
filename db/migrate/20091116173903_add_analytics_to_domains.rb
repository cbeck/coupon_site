class AddAnalyticsToDomains < ActiveRecord::Migration
  def self.up
    add_column :domains, :analytics_code, :string
    
    Domain.reset_column_information
    
    cc = Domain.find_by_url("carolinacoupons.com")
    cc = Domain.find_by_url("cms.local") unless cc
    cc.update_attribute('analytics_code', 'UA-11624655-1') if cc
    
    pc = Domain.find_by_url("penncoupons.com")
    pc = Domain.find_by_url("moneysaver.local") unless pc
    pc.update_attribute('analytics_code', 'UA-11624708-1') if pc
  end

  def self.down
    remove_column :domains, :analytics_code
  end
end
