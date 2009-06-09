# $Id$
class WysiwygEditorRenderer < Renderer
  include WysiwigHelper
  
  def update_content(fieldname, object, options)
    page.replace_html wysiwyg_editor_domid(object), ''
    page.replace_html wysiwyg_content_domid(object), 
      :partial => 'shared/wysiwyg_content', :locals => {:object => object, 
      :fieldname => fieldname, :options => options}

  	page.show wysiwyg_content_domid(object)
  	page.toggle :edit_wysiwyg
	end
  
  # Here's a mind-warper:
  # Try switching fieldname and object args so that object is 1st.
  # Watch in horror as ruby complains that fieldname is not a method!!
  # ???
  def show_editor(fieldname, object, options={})
    page.hide wysiwyg_content_domid(object)
    page.replace_html(wysiwyg_editor_domid(object), 
      :partial => 'shared/fckeditor', 
        :locals => {:object => object, :fieldname => fieldname, :options => options})
    page.show wysiwyg_editor_domid(object)
    page.toggle :edit_wysiwyg
  end
  
  def close_editor(object)
    page.replace_html wysiwyg_editor_domid(object), ''
  end
end
