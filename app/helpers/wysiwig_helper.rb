# $Id$
module WysiwigHelper
  
  def show_wysiwyg_content(object, field, options={})
    use_wysiwyg
    options[:update_url] ||= url_for(object)
    #render :partial => 'shared/wysiwyg_content', :locals => {:object => object, 
    render :partial => 'shared/wysiwyg_edit', :locals => {:object => object, 
      :fieldname => field, :options => options}
  end
  
  def edit_wysiwyg_link(object, field, options={})
    options[:update_url] ||= url_for(object)
    render :partial => 'shared/wysiwyg_edit', :locals => {:object => object, 
      :fieldname => field, :options => options}
  end
  
  def fckeditor_options
    {:toolbarSet => 'RealSimple', :width=>'700px', :height=>'500px', 
      :preview_url => wysiwyg_preview_path}
  end
  
end
