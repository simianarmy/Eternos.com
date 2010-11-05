# $Id$

module ContentSpecHelper
  def text_file
    ActionController::TestUploadedFile.new(ActionController::TestCase.fixture_path + 'foo.txt', Mime::TEXT.to_s)
   end

   def image_file
     fixture_file_upload('porsche.jpg', 'image/jpeg')
   end

   def audio_file
     fixture_file_upload('audio.mp3', 'audio/mpeg')
   end
   
   def video_file
     fixture_file_upload('small_movie.mov', 'video/quicktime')
   end
   
   def web_video_file
     fixture_file_upload('flash_movie.flv', 'video/x-flv')
   end
   
   def attachment_processed?(content)
      not content.read_attribute(:saved_attachment).nil?
   end
   
   def stub_uploads(content)
     content.stubs(:upload).returns(true)
     PhotoThumbnail.any_instance.stubs(:upload).returns(true)
   end
end