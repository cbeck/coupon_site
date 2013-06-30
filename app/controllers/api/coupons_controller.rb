class Api::CouponsController < ApplicationController
  
  def search
    query = "food"  # params[:query]
    lat = 35.035551  # params[:latitude].to_f
    lng = -80.816674 # params[:longitude].to_f
    
    @businesses = Business.search query, :geo => [lat, lng], 
                    :order => "@geodist ASC, @relevance DESC"
        
    # restrict businesses to current site by way of affiliate group  
    # @businesses = filter_businesses(@businesses)

    @coupons = @businesses.collect(&:available_coupons).flatten    
    
    # @coupons = Coupon.find :all, :limit => 5
    render :json => @coupons.to_json
  end
end
