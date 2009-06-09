# $Id$
#
# TagsAutoComplete

module TagsAutoComplete
  # Allows any taggable class to search global tag list
  def auto_complete_for_all_tags
    search_options = {:user_id => current_user.id}
    sql_options = {:limit => params[:limit] || 10}
    @items = Tagging.search(params[:q], search_options, sql_options).map(&:tag).collect(&:name).uniq
    
    render :text => @items.join("\n")
  end
end
    