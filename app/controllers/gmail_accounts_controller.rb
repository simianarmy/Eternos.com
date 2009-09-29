# $Id$

class GmailAccountsController < EmailAccountsController
  before_filter :login_required
  require_role "Member"
  
  def index
    load_accounts
  end
  
  #
  # *******   DEVELOPERS: LEAVE THIS METHOD ALONE!!! *******
  #
  def create
    begin
      # Contacts authenticates in initialization.  If there are any problems logging in, 
      # an exception is raised.
      Contacts::Gmail.new(params[:email][:email], params[:email][:password])

      # At this point authentication has been authorized - create account & add to backup sources
      @current_gmail = GmailAccount.create!(
        :auth_login => params[:email][:email], 
        :auth_password => params[:email][:password], 
        :user_id => current_user.id,
        :backup_site_id => BackupSite.find_by_name(BackupSite::Gmail).id,
        :last_login_at => Time.now)
      @current_gmail.confirmed!
      current_user.completed_setup_step(2)
      @success = true    
      flash[:notice] = "Gmail account saved for backup!"
    rescue Exception => message
      flash[:error] = message.to_s
    end
    
    load_accounts
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @item = current_user.backup_sources.by_site(BackupSite::Gmail).find(params[:id])
    
    respond_to do |format|
      format.js {
        if @item.update_attributes(params[:gmailaccount])
          # hacky but that's how restful_in_place_editor formats stuff.
          params[:editorId] =~ /gmail_account_\d+_(.+)$/
          if $1            
            val = CGI::escapeHTML(@item.send($1).to_s)
            # Passwords must be hidden
            val.gsub!(/./,'*') if $1 == 'auth_password'
              
            render :update do |page|
              page.replace_html(params[:editorId], val)
            end
          else
            render :nothing => true, :status => 200
          end
        else
          flash[:error] = @item.errors.full_messages unless @item.valid?
        end
      }
    end
  end
  
  def destroy    
    begin
      @email = current_user.backup_sources.gmail.find(params[:id])
      @email.destroy
      flash[:notice] = 'Email account removed'
    rescue
      flash[:error] = "Error deleting email account"
    end
      
    respond_to do |format|
      format.js 
    end
  end
  
  private
  
  def load_accounts
    @email_accounts = current_user.backup_sources.gmail.paginate :page => params[:page], :per_page => 10
  end
end