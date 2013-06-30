module SearchHelper
  def path_with_sort(sort)
    url = request.request_uri.gsub(/&?(sort=)\w+/, '')
    url += "?" unless url.include? '?'
    url += "&sort=#{sort}"
  end
end
