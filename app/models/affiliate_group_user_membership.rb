class AffiliateGroupUserMembership < ActiveRecord::Base
  belongs_to :affiliate_group
  belongs_to :user
end
