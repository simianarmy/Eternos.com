# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'linkedin2'
#require 'cobravsmongoose'
oauth_consumer_key = "a9JjbI-dYf91dFUXbtcYEIXDwf8w_BLDnCgijGd7KHGSpaMnv_2MhgbHZaTcsY1w";
oauth_secret_key = "qVrrdR09jGwMlsiEnOfI5IMVIrT2bgC8rAsKi8gFhaliI8o5P9fI2KPko8lFAPD2"

consumer = Linkedin2::Consumer.new(oauth_consumer_key, oauth_secret_key,{
    :oauth_callback=>'oob'
  })



#print consumer.request_token
#print "\n"
#print "oauth_verify:"
#STDOUT.flush
#oauth_verify = gets.chomp
#consumer.access_token(oauth_verify)
@access_token = '2d29367f-0d62-4f61-a591-28fbda9b8fac'
   @secret_token = 'b974e737-dd1c-4023-bbf9-b7468653fa97'
consumer.set_access_token(@access_token, @secret_token)
#@hash_result = CobraVsMongoose.xml_to_hash(consumer.get_profile('publications:(id,title,publisher,authors,date,url,summary),patents:(id,title,summary,number,status,office,inventors,date,url)'))
print consumer.get_profile('publications:(id,title,publisher,authors,date,url,summary),patents:(id,title,summary,number,status,office,inventors,date,url)')



