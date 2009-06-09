# $Id$
#
# controller specs for common settings

describe "controller with common settings on create", :shared => true do  
  describe "with category" do
    it "should display it, and include it in the select options" do
      controller.expects(:ajax_update).never
      CategoriesRenderer.any_instance.expects(:update_selected)
      ajax_update({:category_update => 'Update'}, story_with_new_category)
      @object.reload.category.name.should == 'new_category'
    end
  
    describe "user-submitted" do
      it "should create new category" do
        lambda {
          ajax_update({:category_update => 'Update'}, story_with_new_category)
        }.should change(Category, :count).by(1)
      end
    end
  end
  
end