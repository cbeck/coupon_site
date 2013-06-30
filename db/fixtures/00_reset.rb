
def truncate(tables)
  [tables].flatten.each do |table|
    ActiveRecord::Base.connection.execute("truncate #{table}")
  end
end

# coupons
truncate(['coupons', 'limitations', 'offers', 'images', 'coupon_templates', 'galleries', 'info_boxes'])

# business data
truncate(['businesses', 'people', 'locations','email_addresses', 'phones', 'websites', 'schedules'])

# accounts / users
truncate(['accounts', 'users'])

# other
truncate(['taggings', 'tags', 'clipped_coupons'])
