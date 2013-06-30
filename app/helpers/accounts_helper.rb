module AccountsHelper
  def render_account_class(account)
    output = case
    when account.coupon_templates.blank?
      "no_coupons"
    when account.has_no_active_coupons?
      "no_active"
    when account.has_expiring_coupons?
      "expiring"
    end
    output
  end
end
