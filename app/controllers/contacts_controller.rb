class ContactsController < ApplicationController
  before_filter :admin_required, :except => [:new, :create]
  before_filter :add_layout, :except => [:new, :create]
  
  
  # GET /contacts
  # GET /contacts.xml
  def index
    @contacts = @current_affiliate_group.contacts.all_open.paginate :page => params[:page], :order => 'created_at desc', :include => [:contact_issue, :issue_status]
    logger.info @contacts.inspect
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @contacts }
    end
  end
  
  def resolved
    @contacts = @current_affiliate_group.contacts.resolved.paginate :page => params[:page], :order => 'created_at desc', :include => [:contact_issue, :issue_status]
  end
  
  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = @current_affiliate_group.contacts.find(params[:id])
    @contact.update_attribute(:issue_status_id, IssueStatus[:Open].id) if @contact.new?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new
    if logged_in?
      @contact.name = current_user.name
      @contact.email = current_user.email
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = @current_affiliate_group.contacts.find(params[:id])
  end
  
  def toggle
    @contact = @current_affiliate_group.contacts.find(params[:id])
    case @contact.issue_status_id
    when IssueStatus[:Resolved].id
      @contact.update_attribute(:issue_status_id, IssueStatus[:Open].id)
    else
      @contact.update_attribute(:issue_status_id, IssueStatus[:Resolved].id)      
    end
  end
  
  def flag
    @contact = @current_affiliate_group.contacts.find(params[:id])
    @contact.update_attribute(:issue_status_id, IssueStatus[:Flagged].id)
  end
 
  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = @current_affiliate_group.contacts.build(params[:contact])
    @contact.issue_status = IssueStatus[:New]

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Your message was successfully sent.'
        format.html { redirect_to(home_path) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = @current_affiliate_group.contacts.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(@contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = @current_affiliate_group.contacts.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
  
  
end
