# $Id$
#
# Module providing wrapper around Google Data API gdata gem

module GoogleBackup
  GDATA_AUTHSUB_PEM_FILE = 'eternos.com_gdataprivkey.pem'
  SECURE_AUTHSUB_ENABLED = false
  
  module Auth
    class Base
      attr_reader :client
      
      def authsub_url
        @client.authsub_url(@next_url, @secure, @sess)
      end
      
      protected 
      
      # Private constructor - must instantiate using child class
      def initialize(options={})
        @next_url = options[:callback_url] 
        @sess = true
        @secure = SECURE_AUTHSUB_ENABLED  # set secure = true for signed AuthSub requests
        if options[:auth_token]
          @client.authsub_token = options[:auth_token] 
          # Set private key when upgrading token to session
          @client.authsub_private_key = private_key if @secure
        end
      end
      
      def private_key
        pk_file = File.join(Rails.root, 'config', GDATA_AUTHSUB_PEM_FILE)
        Rails.logger.info "Gdata private key file: #{pk_file}"
        pk_file
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