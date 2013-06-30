module AdPlacementsHelper
  def render_affiliate_group(ad_placement)
    output = "All"
    output = ad_placement.affiliate_group.name unless ad_placement.affiliate_group.nil?
    output
  end
end
