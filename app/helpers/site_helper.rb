module SiteHelper
  
  def render_admin_link(collection, header, sort, anchor = nil)
    param = (collection + "_sort").to_sym
    val = (header == sort) ? (header + "_desc") : header
    link_to header.titleize, admin_path(param => val, :anchor => anchor)
  end
  
  def render_site_name
    AffiliateGroup.current.domain.display_name
  end
end
