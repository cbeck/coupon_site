class AffiliateGroupMembership < ActiveRecord::Base
  belongs_to :affiliate
  belongs_to :affiliate_group
end
