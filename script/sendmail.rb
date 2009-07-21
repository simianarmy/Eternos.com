require 'rubygems'
require 'net/smtp'

CURRENT_PATH = "#{File.dirname(__FILE__)}/.." unless defined?(CURRENT_PATH)
PATH_TO_FILE = "#{CURRENT_PATH}/tmp/emails/#{ARGV[0]}"

SVN_VERSION = File.read("#{CURRENT_PATH}/REVISION")
FROM_ADDRESS  = "svnnotify@190945-web1.eternos.com"
TO_ADDRESS    = "staff@eternos.com"

f = File.new(PATH_TO_FILE)

num, datetime_changed = 0, ""
while !f.eof?
  linetext = f.readline
  num += 1 if linetext.include?("/rails/")
  
  if f.lineno == 2
    tmp = linetext.split("|")
    tmp = tmp[2].split("+")
    datetime_changed = tmp.first
  end
end

humanized_num_file = num.eql?(1) ? "#{num} file was" : "#{num} files were"

msg = <<END_OF_MESSAGE
From: #{FROM_ADDRESS}
To: #{TO_ADDRESS}
Subject: [eternos.com] staging server updated
Content-Type: text/html
The staging website was updated to SVN version #{SVN_VERSION} at #{datetime_changed} and #{humanized_num_file} updated. <br />
Below is the log details. <br /><br />
#{File.read(PATH_TO_FILE).gsub("\n", "<br />")}
END_OF_MESSAGE

Net::SMTP.start('localhost', 25) do |smtp|
   smtp.send_message msg, FROM_ADDRESS, TO_ADDRESS
end