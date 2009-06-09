# $Id$
#
# CommonSettings module - contains methods used by controllers & views that contain
# shared settings like time periods, categories, authorizations, etc.

module CommonSettings
  def load_settings_view_objects(object, params)
    # Save special attributes if not a normal in-place-edit call
    object.reload
    @common_settings = if params[:category_update]
       {:category => object.category}
    elsif params[:time_period_update]
      {:time_period => object.time_period }
    elsif params[:privacy_update]
      {:authorization => object.authorization}
    elsif params[:time_lock_update]
      {:time_lock => object.time_lock}
    end
  end
end