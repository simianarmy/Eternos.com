# $Id$
module CommentsHelper
  
  def view_comments_link(object)
    count = object.comments.count
    capture(render(:partial => 'comments/show', :object => object, :locals => 
      {:comments => object.comments})) do |div|
      l = link_to("Comments (#{count})", '#', :id => "toggle_comments", 
        :class => "toggleable tooltip-target")
      l + div
    end
  end
  
  def toggle_comments_view(comments)
    update_page do |page| 
		  page.toggle :view_comments, :partial => 'comments/index', :locals => {:comments => comments} 
	  end
  end
  
  def comment_author_link(comment)
    if comment.author == current_user
      'You'
    else 
      comment.author.full_name.blank? ? comment.author.email : comment.author.full_name
    end
  end
end
