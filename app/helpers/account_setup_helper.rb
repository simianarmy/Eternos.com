module AccountSetupHelper
  def update_account_setup_layout(page, partial_content)
    page.replace "account-setup-content", :partial => partial_content, :layout => false
  end
  
  def link_to_backup_source_icon(id, name = "", options = {})
    icons = ["facebook-box", "twitter-box", "rss-box", "gmail-box"]
    icons.delete(id)
    link_to_show_hide_online(id, name, icons, options)
  end
end