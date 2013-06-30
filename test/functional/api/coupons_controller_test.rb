require 'test_helper'

class Api::CouponsControllerTest < ActionController::TestCase

  context "on POST to :search" do
    setup do
      @businesses = Array.new(3) { Factory(:business) }
      Business.stubs(:search).returns(@businesses)
      post :search, :query => { :terms => 'food', :longitude => '', :latitude => '' }
    end
    
    should_respond_with :success
    should_respond_with_content_type :json
    should_assign_to :coupons
    should "return all businesses" do
      assert_same_elements @businesses, assigns(:businesses)
      assert_equal 3, assigns(:businesses).size
    end
    should "return available coupons" do
      assert_equal 6, assigns(:coupons).size
    end
  end

end
