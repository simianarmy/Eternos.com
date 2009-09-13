# $Id$

# Module for taking screen captures of web pages

require 'tempfile'
require 'system_timer'

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
      SystemTimer.timeout_after(30.seconds) {
        system "DISPLAY=localhost:1.0 #{capturer} #{CutyCaptOpts} --url='#{url}' --out=#{@out}"
      }
      tmp.delete
      @out
    end
  end
end
    
      