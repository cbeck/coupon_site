require 'demo_data'

@demo = DemoData.new

def account(name, tags=nil)
  @account = Account.create(:name => name, :billing_name => name, 
              :internal_identifier => name.tr("^[A-Za-z0-9]", "").underscore)
  @account.tag_list = tags
  @account.save
  
  (rand(6)+1).times do |i|
    b = @demo.business("#{name} \##{i+1}", '28277')
    b.account = @account
    # b.tag_list = tags
    b.save
  end
  @account.businesses.first.update_attribute :primary, true
  
end

def coupons(acct=@account)
  ct = acct.coupon_templates.create :name => 'Special Offer', :offer_id => 3, :offer_values => '1,2',
        :start_on => Date.today, :expired_on => 60.days.from_now, :enabled => true,
        :limitation_id => 1, :show_website => 1
  acct.businesses.each{|b| ct.coupons.create :business_id => b.id }  
end

account('Anzi Pizza', "restaurant, pizza, pasta") && coupons
account('Pizza Hut', "restaurant, pizza, wings, delivery") && coupons
account('Papa Johns', "restaurant, pizza, wings, delivery") && coupons
account('Bertucci', "restaurant, pizza") && coupons
account('Quiznos', "restaurant, sandwich, fresh") && coupons
account('Subway', "restaurant, sandwich") && coupons
account('The Flying Biscuit', "restaurant, breakfast") && coupons
account('Firebirds', "restaurant, burger, steak") && coupons
account('Salsaritas', "restaurant, mexican") && coupons
account('Tuffy', "auto, service") && coupons
account('Mr. Goodyear', "auto, service, tires") && coupons
account('Tire Kingdom', "auto, tires") && coupons
account('Jiffy Lube', "auto, oil change") && coupons

