require 'fileutils'

swfobject = File.dirname(__FILE__) + '/../../../public/javascripts/swfobject.js'
FileUtils.cp File.dirname(__FILE__) + '/assets/swfobject.js', swfobject unless File.exist?(swfobject)

#expressInstall = File.dirname(__FILE__) + '/../../../public/swfs/expressinstall.swf'
#FileUtils.cp File.dirname(__FILE__) + '/assets/expressinstall.swf', expressInstall unless File.exist?(expressInstall)

puts IO.read(File.join(File.dirname(__FILE__), 'README'))