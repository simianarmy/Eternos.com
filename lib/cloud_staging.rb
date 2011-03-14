# Mixin containing filesystem methods related to storage of files 
# that are queued to be uploaded to S3

module CloudStaging
  # OVERRIDES FOR attachment_fu
  # Overwrite this method in your model to customize the filename.
  # The optional thumbnail argument will output the thumbnail's filename.
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(cloud_staging_dir, file_system_path, *partitioned_path(thumbnail_name_for(thumbnail)))
  end

  # Used as the base path that #public_filename strips off full_filename to create the public path
  def base_path
    @base_path ||= File.join(cloud_staging_dir, 'public')
  end
  
  # Helper method for non-content classes
  def cloud_staging_dir
    if !AppConfig.s3_staging_dir.nil? 
      if (AppConfig.s3_staging_dir.first == '/')
        AppConfig.s3_staging_dir
      else
        File.join(Rails.root, AppConfig.s3_staging_dir)
      end
    else
      Rails.root
    end
  end
end