ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
end
