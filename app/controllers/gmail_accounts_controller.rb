# $Id$

class GmailAccountsController < EmailAccountsController
  before_filter :login_required
  require_role "Member"
  
  def update
    @item = current_user.backup_sources.by_site(BackupSite::Gmail).find(params[:id])
    @item.update_attributes(params[:gmailaccount])
    
    respond_to do |format|
      format.js {
        # hacky but that's how restful_in_place_editor formats stuff.
        params[:editorId] =~ /gmail_account_\d+_(.+)$/
        if $1
          render :update do |page|
            page.replace_html(params[:editorId], CGI::escapeHTML(@item.send($1).to_s))
          end
        else
          render :nothing => true, :status => 200
        end
      }
    end
  end
end