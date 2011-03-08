# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'linkedin2'
#require 'cobravsmongoose'
oauth_consumer_key = "a9JjbI-dYf91dFUXbtcYEIXDwf8w_BLDnCgijGd7KHGSpaMnv_2MhgbHZaTcsY1w"
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
@access_token = 'e6658dba-7e2d-48fd-abc4-538ca48384c7'
@secret_token = 'e756579d-1a44-4f94-af4f-07b1f123cf53'
consumer.set_access_token(@access_token, @secret_token)
#@hash_result = CobraVsMongoose.xml_to_hash(consumer.get_profile('publications:(id,title,publisher,authors,date,url,summary),patents:(id,title,summary,number,status,office,inventors,date,url)'))
print consumer.get_profile('publications:(id,title,publisher,authors,date,url,summary),patents:(id,title,summary,number,status,office,inventors,date,url)')



