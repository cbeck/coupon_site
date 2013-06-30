module ReportsHelper
  
  def render_sort_link(collection, header, sort)
    param = (collection + "_sort").to_sym
    val = (header == sort) ? (header + "_desc") : header
    link_to header.titleize, :action => controller.action_name, param => val
  end
end
