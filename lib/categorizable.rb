module Categorizable
  # creates new category if necessary
   def new_category_name=(cat)
     if !cat.blank?
       #categories.clear
       build_category(:name => cat)
     end
   end

   # # Mass-assignment helper to set story category
   #    def category_attributes=(attributes)
   #      if !attributes[:category].blank? and (cat = Category.find(attributes[:category]))
   #        #categories.clear
   #        category = cat
   #      end
   #    end
end
