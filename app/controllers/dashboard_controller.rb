class DashboardController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_connect_session
  before_filter :load_member_home_presenter
  layout 'member'
  
  ssl_required :all # Way nicer than specifying each frickin action
  
  def show
    @user = current_user
    @days_signed = (Date.current - @user.created_at.to_date + 1).to_i.to_s
    @backup_data = {:size => 0, :photos => 0, :videos => 0, :total => 0}
    
    @user.contents.each do |item|
      @backup_data[:total] += 1
      @backup_data[:size] += item.size
      @backup_data[:photos] += 1 if item.is_a?(Photo)
      @backup_data[:videos] += 1 if item.is_a?(Video) || item.is_a?(WebVideo)
    end
    @as_items = @user.activity_stream.items.size
    @backup_sources = @user.backup_sources.size
    @active_backup_sources = @user.backup_sources.active.size
  end

  def edit_profile
    @user = current_user
    @address = @user.address_book.addresses.first(:conditions => {:location_type => 'home'})
    @address = @user.address_book.addresses.build unless @address
  end

  def regions
    @regions = params['c_id'].empty? ? [] : Region.find(:all,
                           :conditions => {:country_id => params['c_id']},
                           :order => :name).map{|reg| {:name => reg.name, :id => reg.id}}
    @regions.unshift({:name => params['c_id'].empty? ? '&lt;Select country&gt;' : '&lt;Select region&gt;', :id => nil})
    @curr_reg = @regions.select {|reg| reg[:id].to_s == params[:curr]}.first
    @curr_reg = @curr_reg[:id] if @curr_reg
    respond_to do |format|
      format.html {render :layout => false}
    end
  end
end
