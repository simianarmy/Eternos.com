# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/av_attachment_spec_helper')

describe Content do
  include ContentSpecHelper
  
  it "should return class containing content-type" do
    Content.class_from_content_type('text/plain').should == 'Document'
  end
  
  it "should be valid with unknown type" do
    @content = Content.factory
    @content.should be_an_instance_of Document
  end
  
  it "should handle incorrect file data when detecting content type" do
    lambda {
      Content.detect_mimetype(nil)
    }.should_not raise_error
  end
  
  it "should detect content type from valid file" do
    type = Content.detect_mimetype(image_file)
    type.should == 'image/jpeg'
  end
  
   it "should take user object as owner attribute" do
     c = new_content(:type => :text, :owner => @member = create_member)
     c.owner.should be_eql(@member)
   end

   describe "on new" do  
    before(:each) do
      @content = new_content(:type => :text)
    end
  
    it "should not be valid without required attributes" do
      @content.should be_valid
      @content.title = nil
      @content.should_not be_valid
    end
  
    it "should have title set automatically" do
      @content.title.should_not be_empty
    end
  
    it "to_s should return string with filename and size" do
      @content.to_s.should match(/#{@content.filename}/)
      @content.to_s.should match(/\d+\s\w+/)
    end
  
    it "should not be a recording" do
      @content.should_not be_recording
    end
    
    describe "" do
      before(:each) do
        @object = @content
      end
      it_should_behave_like "a new object with av attachment"
    end
  end

  describe "on create" do 
    before(:each) do
      @content = new_content(:type => :photo)
      @content.stubs(:upload).returns(true)
    end

    it "should create object" do
      lambda {
        @content.save
      }.should change(Content, :count).by(1)
    end

    it "title should be set to filename without extension, by default" do
      @content.save
      @content.filename.should_not == 'Document'
    end

    it "should create file on disk in assets directory" do
      @content.save
      assert File.exists?(@content.full_filename)
      @content.public_filename.should match(/assets/)
    end
    
    describe "" do
      before(:each) do
        @content.save
        @object = @content
      end
      it_should_behave_like "an object with av attachment"
    end
  end
  
  describe "after create" do
    before(:each) do
      @content = new_content(:type => :photo)
    end
    
    with_transactional_fixtures :off do    
      it "should upload the file to cloud storage" do
        @content.expects(:upload)
        @content.save
      end
    end
  end

  describe"on update" do
    before(:each) do
      @content = create_content(:type => :photo)
    end

    with_transactional_fixtures :off do
     it "should not try to launch upload worker" do
       @content.expects(:upload).never
       @content.update_attributes(:title => 'foo')
     end
   end
  end

  describe "create with document" do
    before(:each) do
      @content = create_content(:type => :text)
      @content.stubs(:upload).returns(true)
    end
  
    it "should not be thumbnailable" do
      @content.should_not be_thumbnailable
    end

    it "should be converted to the proper sti type" do
      @content.should be_an_instance_of Document
    end
  end

  describe "association" do
    include UserSpecHelper
 
    before(:each) do
      @content = create_content(:type => :text)
      @content.stubs(:upload).returns(true)
    end
  
    it "association should be valid" do
      @content.owner.contents.first.should be_eql(@content)
    end
  end

  describe "create with image" do
    def validate_files_on_disk(c)
      File.exists?(c.full_filename).should be_true
      File.exists?(c.full_filename(:thumb)).should be_true
    end
    
    before(:each) do
      @content = create_content(:type => :photo)
    end
  
    it "should be an object of the correct class" do
      @content.should be_a_kind_of Content
      @content.should be_an_instance_of Photo
    end
  
    it "should be an image" do
      @content.should be_image
    end
  
    it "should be thumbnailable" do
      @content.should be_thumbnailable
    end
  
    it "should have a valid taken at date" do
      @content.taken_at.should_not == ''
    end
    
    it "should save file to disk in assets directory" do
      assert File.exists?(@content.full_filename)
    end
    
    it "should be associated with a thumbnail" do
      @content.thumbnails.should have(1).thing
      @content.thumbnails.first.should be_an_instance_of PhotoThumbnail
      validate_files_on_disk @content
    end
    
    it "should create thumbnail when temp_path param used" do
      @filename = ActionController::TestCase.fixture_path + 'porsche.jpg'
      c = Content.factory(
        :owner => create_member,
        :content_type => Content.detect_mimetype(@filename),
        :description => 'caption',
        :filename => File.basename(@filename),
        :temp_path => File.new(@filename))
      c.save.should be_true
      c.thumbnails.should have(1).thing
      validate_files_on_disk c
    end
  end
end

describe Content, "create with audio" do
  include ContentSpecHelper
  
  before(:each) do
    @content = create_content(:type => :audio)
    @content.stubs(:upload).returns(true)
  end
  
  it "should be an object of the correct class" do
    @content.should be_a_kind_of Content
    @content.should be_an_instance_of Music
  end
  
end

describe Content, "on image destroy" do
  include ContentSpecHelper
  
  before(:each) do
    @content = create_content(:type => :photo)
    @content.stubs(:upload).returns(true)
  end
  
  it "should delete files on disk" do
    @content.thumbnails.should_not be_empty
    file = @content.full_filename
    assert File.exists?(file)
    @content.destroy
    assert !File.exists?(file)
  end
  
  it "should delete associated thumbnails" do
    @content.thumbnails.should_not be_empty
    thumb_id = @content.thumbnails.first.id
    thumb = @content.full_filename(:thumb)
    assert File.exists?(thumb)
    @content.destroy
    lambda {
      PhotoThumbnail.find(thumb_id)
      }.should raise_error
    assert !File.exists?(thumb)
  end
end

