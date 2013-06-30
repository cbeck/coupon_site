class CategoriesController < ApplicationController
  before_filter :init_search
  before_filter :show_search
  
  def index
    @categories = Tag.find :all, :conditions => ['name in (?)', SiteConfig['popular_categories'].to_a], :order => 'name ASC'
  end
  
  def show
    @cat1 = Tag.find(params[:cat1])
    @cat2 = Tag.find(params[:cat2]) rescue nil
    @cat3 = Tag.find(params[:cat3]) rescue nil
    @tags = [@cat1, @cat2, @cat3].reject{|c|c.nil?}

    # find the intersection of all taggables in these tags; include all businesses for an Account tag
    taggables = @tags.collect{|c| 
      c.taggings.collect{|t| 
        all = [t.taggable]
        all << t.taggable.businesses if t.taggable.is_a?(Account)
        all
      }.flatten
    }
    taggables = taggables.inject{|list, t| list & t}
    
    # find the accounts for the resulting set
    @accounts = taggables.select{|t| t.is_a?(Account) }
    @accounts << taggables.collect{|t| t.account if t.is_a?(Business)}
    @accounts = @accounts.flatten.reject{|a|a.nil?}.uniq
    @accounts = filter_accounts(@accounts)

    # get all available coupons for these accounts
    @available_coupons = @accounts.collect{|a| a.coupon_templates.active}.flatten.uniq
    
    # now get all related tags that will yield results if clicked
    # related = taggables.collect{|t| t.tags}.flatten
    related = @available_coupons.collect{|c| c.account.tags + c.businesses.collect(&:tags) }.flatten.uniq

    @categories = related - @tags
    @categories = @categories.sort_by {|cat| cat.name } unless @categories.blank? 
    
  end

end
