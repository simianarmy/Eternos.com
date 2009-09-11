# $Id$

# Module for taking screen captures of web pages

require 'tempfile'

module ScreenCapture
  @@capturer = '/usr/local/bin/CutyCapt' 
  CutyCaptOpts =  '--max-wait=15000' # 15 seconds max.
  mattr_reader :capturer
  
  class << self
    # Takes screencap and saves to file, returns filename
    def capture(url, ext='png')
      return unless File.exist? capturer
      
      tmp = Tempfile.new('screencap')
      @out = "#{tmp.path}.#{ext}"
      system "#{capturer} #{CutyCaptOpts} --url='#{url}' --out=#{@out}"
      tmp.delete
      @out
    end
  end
end
    
      