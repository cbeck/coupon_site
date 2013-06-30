module DomainsHelper
  def render_site_logo(domain, type = :small)
    (domain.logo) ? ((type == :media) ? media_link(domain.logo) : small_link(domain.logo)) : ''
  end
end
