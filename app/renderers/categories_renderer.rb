# $Id$
class CategoriesRenderer < Renderer
  def update_selected(category, container, container_domid)
    page.replace_html container_domid, category.name
    page.visual_effect :highlight, container_domid
    # Reload hidden form partial with possible new values
    page.replace_html :category_select, display_category_select(container, :ajax=>true)
    page.toggle :category_select
  end
end
