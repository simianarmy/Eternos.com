# $Id$
module CategoriesHelper
  def display_category_select(object, locals={})
    locals[:categories] ||= current_user.categories
    render :partial => (locals[:ajax].blank?) ? 
      'shared/category_select_form' : 'shared/ajax_category_select_form',
      :object => object, :locals => locals
  end
  
  def print_categories(categories=[])
    categories.map(&:name).join(', ')
  end
  
  # Returns categories collection passed + global categories, for form select
  def categories_for_select(cats)
    Category.globals(:all) + cats
  end
end
