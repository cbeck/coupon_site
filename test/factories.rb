
Factory.define :affiliate do |a|
  a.name 'Moneysaver'
end


Factory.define :account do |a|
  a.association :affiliate
  a.name 'Pizzeria Foo'
end

Factory.define :coupon_template do |t|
  t.association :account
  t.name 'Web Special'
  t.enabled true
  t.start_on 1.week.ago.to_date
  t.expired_on 1.month.from_now.to_date
end

Factory.define :coupon do |c|
  c.association :coupon_template
end

Factory.define :business do |b|
  b.coupons {|c| [c.association(:coupon), c.association(:coupon)]}
  b.name 'foobar'
end


