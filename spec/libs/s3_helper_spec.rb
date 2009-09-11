require File.dirname(__FILE__) + '/../spec_helper'

describe S3Connection do
  describe S3Uploader do
    it "should allow multiple simultaneous buckets" do
      @s3 = S3Uploader.create(:email)
      @s3.bucket.to_s.should == S3Buckets::EmailBucket.eternos_bucket_name
      @s3.set_bucket(:media)
      @s3.bucket.to_s.should == S3Buckets::MediaBucket.eternos_bucket_name
      @s3.bucket(:email).to_s.should == S3Buckets::EmailBucket.eternos_bucket_name
    end

    describe "" do
      before(:each) do
        @s3 = S3Uploader.instance
        @bucket_name = @s3.bucket.to_s
        @bucket = @s3.bucket
      end

      after(:each) do
        # Delete test bucket
        @s3.bucket.object.clear
      end
      
      it "should return bucket object" do
        @s3.bucket.object.should be_a AWS::S3::Bucket
        @bucket.should_not be_nil
      end

      describe "on new" do
        it "should use default bucket class without args" do
          @s3.bucket.should == S3Buckets::MediaBucket
        end

        it "should generate url to object" do
          @s3.url('somewhere').should match(/#{@s3.bucket.to_s}\/somewhere$/)
        end

        it "bucket should have acl property" do
          @bucket.access_level.should_not be_blank
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
      end

      describe "on upload" do
        def upload_image
          @object = create_content(:type => :photo)
          @s3.upload(@object.full_filename, @object.public_filename, :content_type => @object.content_type)
        end

        before(:each) do
          @s3.s3_key = nil
        end

        it "should store file in bucket" do
          upload_image
          AWS::S3::S3Object.exists?(@object.public_filename, @bucket_name).should be_true
        end

        it "should raise error if key queried before an upload" do
          lambda { @s3.key }.should raise_error
        end

        it "should store file in bucket" do
          upload_image
          AWS::S3::S3Object.exists?(@object.public_filename, @bucket_name).should be_true
        end

        it "should return generate object key on upload" do
          upload_image
          @s3.key.should_not be_nil
        end

        describe "with public acl" do
          it "stored object should be accessible via url" do
            upload_image
            @s3.url.should_not be_blank
            Curl::Easy.perform(@s3.url).body_str.should_not match(/AccessDenied/)
          end
        end
      end
    end
  end

  describe S3Downloader do
    describe "fetching existing object" do
      before(:each) do
        # both need to point at same bucket
        @s3 = S3Uploader.instance
        @s3.set_bucket(:media)
        @s3.bucket.object.clear
        @s3.store('test', 'foo fa')
        @s3_down = S3Downloader.new
        @s3_down.set_bucket(:media)
      end
      
      it "fetch should return s3 object" do
        @s3_down.fetch('test').value.should == 'foo fa'
      end

      it "fetch_value should return s3 value" do
        @s3_down.fetch_value('test').should == 'foo fa'
      end
    end
  end
end