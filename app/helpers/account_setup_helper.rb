module AccountSetupHelper
  def update_account_setup_layout(page, partial_content)
    page.replace "account-setup-content", :partial => partial_content, :locals => {:settings => @settings}, 
      :layout => false
  end
  
  def link_to_backup_source_icon(id, name = "", options = {})
    icons = ["facebook-box", "twitter-box", "rss-box", "gmail-box"]
    icons.delete(id)
    link_to_show_hide_online(id, name, icons, options)
  end
  
  def gen_step_class(step, active_step)
    (active_step == step) ? "step#{step}-active" : (active_step > step) ? "step#{step}complete-btn" : "step#{step}-btn"
  end
  
  def needs_account_setup(user)
    user.setup_step < 2 #0 && session[:setup_account].nil?
  end
end
