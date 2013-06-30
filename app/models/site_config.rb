class SiteConfig < ActiveRecord::Base
  acts_as_enumerated
  
  def to_i
    value.to_i
  end
  
  def to_s
    value
  end
  
  def to_a
    @arr ||= value.split /\s*,\s*/
  end
  
  def to_sorted_array
    to_a.sort
  end
  
end
