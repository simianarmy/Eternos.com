module AccountSetupHelper
  def update_account_setup_layout(page, partial_content)
    page.replace "account-setting-content", :partial => partial_content, :layout => false
  end
end
