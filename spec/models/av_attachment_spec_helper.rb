# $Id$

describe "a new object with av attachment", :shared => true do
  before(:each) do
    @recording = mock_model(Recording)
  end
  
  it "should create av association" do
    lambda {
      @object.recording = @recording
      @object.save
    }.should change(AvAttachment, :count).by(1)
  end
  
  it "should assign recording from id" do
    Recording.expects(:find).with(@recording.id).returns(@recording)
    @object.recording_id = @recording.id
    @object.save
    @object.attached_recording.id.should == @recording.id
  end
  
  it "should return av attachment recording on query after saving" do
    @object.recording = @recording
    @object.save
    @object.attached_recording.id.should == @recording.id
  end
end

describe "an object with av attachment", :shared => true do
  before(:each) do
    @recording = mock_model(Recording)
    @object.recording = mock_model(Recording)
    @object.save
  end
  
  it "should update av association object" do
    @object.recording = @recording
    @object.attached_recording.id.should == @recording.id
  end
  
  it "should replace existing av association object" do
    lambda {
      @object.recording = @recording
    }.should change(AvAttachment, :count).by(1)
  end
  
  it "should delete av attachments but not recordings on destroy" do
    lambda {
      @object.destroy
    }.should change(AvAttachment, :count).by(1) && change(Recording, :count).by(0)
  end
end