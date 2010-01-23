# $Id$
#
# Module providing wrapper around Google Data API gdata gem

module GoogleBackup
  module Auth
    class Base
      attr_reader :client
      
      def authsub_url
        #@client.authsub_private_key = PRIVATE_KEY
        @client.authsub_url(@next_url, @secure, @sess)
      end
      
      protected 
      
      # Private constructor - must instantiate using child class
      def initialize(options={})
        #PRIVATE_KEY = '/path/to/private_key.pem'
        @next_url = options[:callback_url] 
        @secure = false  # set secure = true for signed AuthSub requests
        @sess = true
        @client.authsub_token = options[:auth_token] if options[:auth_token]
      end
    end
    
    class Picasa < Base
      def initialize(options={})
        @client = GData::Client::Photos.new
        super(options)
      end
      
      # Convenience method to fetch account title - should be in PicasaReader class but that 
      # code is in backupd repo for now.  Move to Gem?
      def account_title
        xml = client.get('http://picasaweb.google.com/data/feed/api/user/default').to_xml
        title = xml.elements['author'].elements['uri'].text
      end
    end
  end
end