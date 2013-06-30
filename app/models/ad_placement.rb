class AdPlacement < ActiveRecord::Base
  belongs_to :ad_block
  belongs_to :ad
  belongs_to :affiliate_group
  
  named_scope :available_for_affiliate_group_by_block, lambda { |ad_block_id|
    {:conditions => ['ad_block_id = ? and affiliate_group_id IS NULL or affiliate_group_id = ?', ad_block_id, AffiliateGroup.current.id]}
  }
  
  acts_as_list
  
  validates_uniqueness_of :ad_id, :scope => :ad_block_id, :message => "may be placed only once in a given location."
  
end
