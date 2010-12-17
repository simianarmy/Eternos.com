class FacebookPageAdmin < ActiveRecord::Base
  belongs_to :facebook_page
  belongs_to :facebook_account
end
