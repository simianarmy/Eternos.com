# This should be included by any class that needs to access the S3 cloud 
# staging directory.
# For now, adding to an initializer

def cloud_staging_dir
  AppConfig.s3_staging_dir.first == '/' ? 
    AppConfig.s3_staging_dir : 
    File.join(Rails.root, AppConfig.s3_staging_dir)
end