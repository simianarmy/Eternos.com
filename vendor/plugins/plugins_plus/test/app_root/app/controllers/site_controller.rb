class SiteController < ApplicationController
  def app_layout_app_view
    render :layout => 'app_layout'
  end
  
  def app_layout_plugin_view
    render :layout => 'app_layout'
  end
  
  def app_layout_app_and_plugin_view
    render :layout => 'app_layout'
  end
  
  def plugin_layout_app_view
    render :layout => 'plugin_layout'
  end
  
  def plugin_layout_plugin_view
    render :layout => 'plugin_layout'
  end
  
  def plugin_layout_other_plugin_view
    render :layout => 'plugin_layout'
  end
  
  def plugin_layout_app_and_plugin_view
    render :layout => 'plugin_layout'
  end
end
