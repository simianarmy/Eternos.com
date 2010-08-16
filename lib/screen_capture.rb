# $Id$

# Module for taking screen captures of web pages

require 'tempfile'
require 'system_timer'

module ScreenCapture
  ScreenCapBin = 'CutyCapt'
  @@capturer = "/usr/local/bin/#{ScreenCapBin}" 
  BinOpts =  '--max-wait=15000' # 15 seconds max.
  mattr_reader :capturer
  
  class << self
    @@timeout_seconds = 2.minutes # Shouldn't take longer than this
    
    # Takes screencap and saves to file, returns filename
    def capture(url, ext='png')
      return unless File.exist? capturer
      
      tmp = Tempfile.new('screencap')
      @out = "#{tmp.path}.#{ext}"
      puts "saving screencap to #{@out}..."
      begin
        SystemTimer.timeout_after(@@timeout_seconds) {
          system "DISPLAY=localhost:1.0 #{capturer} #{BinOpts} --url='#{url}' --out=#{@out}"
        }
      rescue Timeout::Error => e
        puts "Timeout saving screencap (#{@@timeout_seconds} s. max): #{e.message}..killing process"
        system "pkill #{ScreenCapBin}"
        @out = nil
      ensure
        tmp.delete
      end
      puts "screencap done."
      @out
    end
  end
end
    
      