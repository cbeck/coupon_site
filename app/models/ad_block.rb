class AdBlock < ActiveRecord::Base
  has_many :ad_placements, :dependent => :destroy
  has_many :ads, :through => :ad_placements
  
  def available_ads
    ad_placements = AdPlacement.available_for_affiliate_group_by_block(self.id)
    adverts = ad_placements.collect(&:ad)
    a = adverts.select(&:enabled)
    avail = available_placements-1
    a[0..avail]
  end
end
