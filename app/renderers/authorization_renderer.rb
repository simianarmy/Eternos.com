# $Id$
#

class AuthorizationRenderer < Renderer
  def update(on_partial=false)
    page.hide :auth_select_partial
    page.visual_effect :highlight, :message_permissions
    if on_partial
      page.show :toggle_auth_select_partial
    else
      page.hide :toggle_auth_select_partial
    end
  end
end
    