require File.dirname(__FILE__) + '/../spec_helper'

  
describe S3Uploader do
  before(:each) do
    @s3 = S3Uploader.new
    @bucket_name = @s3.bucket.to_s
    @bucket = @s3.bucket
  end
  
  it "should return bucket object" do
    @s3.bucket.object.should be_a AWS::S3::Bucket
  end
  
  after(:each) do
    # Delete test bucket
    AWS::S3::Bucket.delete(@bucket_name, :force => true)
  end
  
  describe "on new" do
    before(:each) do
      @bucket.object.clear
    end
    
    it "should use default bucket class without args" do
      @s3.bucket.should == S3Buckets::MediaBucket
    end

    it "should generate url to object" do
      @s3.url('somewhere').should match(/#{@s3.bucket.to_s}\/somewhere$/)
    end

    it "should store string to bucket using base api" do
      size = @bucket.size
      @s3.store('test', "foo foo")
      AWS::S3::Bucket.find(@bucket_name).objects.first.value.should == "foo foo"
      @bucket.size.should == size+1
    end

    it "should overwrite existing string in bucket" do
      size = @bucket.size
      @s3.store('test', "foo foo")
      @s3.store('test', 'faa foo')
      @bucket.object['test'].value.should == 'faa foo'
      @bucket.size.should == size+1
    end

    it "should store file in bucket" do
      @object = create_content(:type => :photo)
      @s3.upload(@object.full_filename, @object.public_filename, @object.content_type)
      AWS::S3::S3Object.exists?(@object.public_filename, @bucket_name).should be_true
    end
    
    it "should raise error if key queried before an upload" do
      lambda { @s3.key }.should raise_error
    end
    
    it "should return generate object key on upload" do
      @object = create_content(:type => :photo)
      @s3.upload(@object.full_filename, @object.public_filename, @object.content_type)
      @s3.key.should_not be_nil
    end
  end
end

describe S3Downloader do
  before(:each) do
    @s3 = S3Downloader.new
  end
  
  describe "fetching existing object" do
    before(:each) do
      S3Uploader.new.store('test', 'foo fa')
    end
    
    it "fetch should return s3 object" do
      @s3.fetch('test').value.should == 'foo fa'
    end
    
    it "fetch_value should return s3 value" do
      @s3.fetch_value('test').should == 'foo fa'
    end
  end
end
      