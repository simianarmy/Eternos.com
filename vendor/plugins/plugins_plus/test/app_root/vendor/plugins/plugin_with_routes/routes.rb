with_options(:controller => 'plugin_with_routes_controller') do |map|
  map.plugin_with_app_layout 'plugin_with_routes', :action => 'index'
end
