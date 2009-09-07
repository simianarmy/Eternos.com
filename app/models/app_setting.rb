# $Id$

class AppSetting < ActiveRecord::Base
  encrypt_attributes :suffix => '_c'
end