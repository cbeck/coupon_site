require 'location'

module Netphase
  
  class BusinessesController < ApplicationController
    before_filter :login_required

    def index
      @businesses = Business.find(:all)
    end

    def show
      @business = Business.find(params[:id])
    end

    def new
      @business = Business.new
      @business.location = Location.new :country => 'US'
      @business.schedule = Schedule.default
      @business.people << Person.new(:required => true)
      @business.phones << Phone.new(:main => true)
      @business.email_addresses << EmailAddress.new(:required => true)
    end

    def edit
      @business = Business.find(params[:id])
    end

    def create
      @business = Business.create(params[:business])
      if @business.save
        flash[:notice] = 'Business was successfully created.'
        redirect_to(@business)
      else
        render :action => "new"
      end
    end

    def update
      @business = Business.find(params[:id])
      if @business.update_attributes(params[:business])
        flash[:notice] = 'Business was successfully updated.'
        redirect_to(@business)
      else
        render :action => "edit"
      end
    end

    def destroy
      @business = Business.find(params[:id])
      @business.destroy
      redirect_to(businesses_url)
    end
    
  end
  
end
