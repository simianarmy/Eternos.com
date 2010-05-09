# $Id$
#
# TagsAutoComplete

module TagsAutoComplete
  # Allows any taggable class to search global tag list
  def auto_complete_for_all_tags
    sql_options = {:limit => params[:limit] || 10}
    @items = Tagging.tagger_id_eq(current_user.id).search(params[:q]).map(&:tag).collect(&:name).uniq
    
    render :text => @items.join("\n")
  end
end
    