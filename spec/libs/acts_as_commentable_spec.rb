it "should allow comments to be assigned" do
    @content.comments = [create_comment]
    @content.save
    @content.reload.comments.should_not be_empty
end