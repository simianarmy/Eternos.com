require File.dirname(__FILE__) + '/../spec_helper'

  
describe S3Uploader do
  before(:each) do
    @s3 = S3Uploader.new
    @bucket_name = @s3.bucket.to_s
    AWS::S3::Bucket.create(@bucket_name)
    @bucket = @s3.bucket.find
  end
  
  after(:each) do
    # Delete test bucket
    AWS::S3::Bucket.delete(@bucket_name, :force => true)
  end
  
  describe "on new" do
    it "should use default bucket class without args" do
      @s3.bucket.name.should == S3Buckets::Media.name
    end

    it "should generate url to object" do
      @s3.url('somewhere').should match(/#{@s3.bucket.to_s}\/somewhere$/)
    end

    it "should be connected" do
      @s3.bucket.should be_connected
    end

    it "should have empty bucket" do
      @bucket.should be_empty
    end

    it "should store string to bucket using base api" do
      @s3.store("test", "foo foo")
      AWS::S3::Bucket.find(@bucket_name).objects.first.value.should == "foo foo"
      @bucket.size.should == 1
    end

    it "should overwrite existing string in bucket" do
      @s3.store("test", "foo foo")
      @bucket.size.should == 1
      @s3.store('test', 'faa foo')
      @bucket['test'].value.should == 'faa foo'
      @bucket.size.should == 1
    end

    it "should store file in bucket" do
      @object = create_content(:type => :photo)
      @s3.upload(@object.full_filename, @object.public_filename, @object.content_type)
      AWS::S3::S3Object.exists?(@object.public_filename, @bucket_name).should be_true
    end
  end
end