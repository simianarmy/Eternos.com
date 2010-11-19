# BackupSource STI class representing a Facebook account

class FacebookAccount < BackupSource
  has_many :facebook_page_admins
  has_many :pages, :through =>:facebook_page_admins, :source => :facebook_page
end