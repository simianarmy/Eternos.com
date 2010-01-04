# $Id$

class Person < ActiveRecord::Base
  validates_presence_of :name, :message => "Please enter a full name"
  
  has_attached_file :photo, 
    :styles => { :thumb => "100x100" },
    :storage => :s3,
    # Parse credentials into hash on load since file might disappear after deploy
    # when this file is used by non-Rails apps (ie. backup daemons)
    :s3_credentials => YAML.load_file("#{RAILS_ROOT}/config/amazon_s3.yml"),
    :s3_headers => {'Expires' => 1.year.from_now.httpdate},
    :url => ":class/:id/:basename_:style.:extension",
    :path => ":class/:id/:basename_:style.:extension",
    :bucket => S3Buckets::MediaBucket.eternos_bucket_name

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :photo, :less_than => 1.megabytes
  
  attr_protected :photo_file_name
end
