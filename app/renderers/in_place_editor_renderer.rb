# $Id$
class InPlaceEditorRenderer < Renderer
  def update(object, params)
    if domId = params[:editorId] || params[:domId]
      page.visual_effect :highlight, domId, :duration => 2.0 # if flash[:error]
      
      # Get editor attribute in form params
      attribute = if params[object.class.to_s.underscore.to_sym]
        params[object.class.to_s.underscore.to_sym].keys.first
      elsif params[object.class.base_class.to_s.underscore.to_sym]
        # Use object base class as hash key if none found for object
        params[object.class.base_class.to_s.underscore.to_sym].keys.first
      end
      
      if attribute and object.respond_to?(attribute)
        page.replace_html(domId, object.send(attribute)) 
      end
      # Stop ajax spinner 
      page.call "spinner.unload"
    end
  end
end
