# $Id$

class GmailAccountsController < EmailAccountsController
  before_filter :login_required
  require_role "Member"
  
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
end