class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :load_artifacts, :except => [:index, :destroy]
  require_role "Member"
  
  include CommonSettings
  include TagsAutoComplete
    
  # GET /messages
  # GET /messages.xml
  def index
    @messages = current_user.messages.search_text(params[:search], current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = current_user.messages.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = current_user.messages.new
    @message.message = I18n.t('messages.new.message')
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = current_user.messages.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = current_user.messages.new(params[:message])
    
    respond_to do |format|
      if @message.save
        format.html { flash_redirect("Your entry has been successfully created!", 
          @message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = current_user.messages.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        load_settings_view_objects(@message, params)
        
        flash[:notice] = "Message updated!"
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
        format.js {
          flash[:error] = @message.errors.full_messages
          @message.reload
        }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_path }
      format.xml  { head :ok }
    end
  end
  
  private
end
