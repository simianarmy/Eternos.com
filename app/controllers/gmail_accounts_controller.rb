# $Id$

class GmailAccountsController < EmailAccountsController
  before_filter :login_required
  require_role "Member"
  
  def index
    load_accounts
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
      current_user.backup_sources.by_site(BackupSite::Gmail).find(params[:id]).destroy
      flash[:notice] = 'Email account removed'
    rescue
      flash[:error] = "Error deleting email account"
    end

    load_accounts
    
    respond_to do |format|
      format.js 
    end
  end
  
  private
  
  def load_accounts
    @email_accounts = current_user.backup_sources.by_site(BackupSite::Gmail).paginate :page => params[:page], :per_page => 10
  end
end