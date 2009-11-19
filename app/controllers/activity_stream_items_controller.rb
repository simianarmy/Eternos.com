# $Id$

class ActivityStreamItemsController < ApplicationController
  before_filter :login_required
  require_role ['Guest', 'Member']

  # Use our authorization dsl here
  before_filter :load_item, :only => [:show, :edit, :update, :destroy]
  
  protected 
    
end
