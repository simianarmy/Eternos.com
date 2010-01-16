# $Id$

class PicasaWebAccount < BackupSource
  @@display_title = 'Picasa Web Albums'
  cattr_reader :display_title
  
  validates_presence_of :auth_token, :message => "Missing authentication token"
  validates_uniqueness_of :auth_token, :scope => :user_id, :message => "Account already created"
end