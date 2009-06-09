# $Id$
class PhoneNumber < ActiveRecord::Base
  belongs_to :phoneable, :polymorphic => true
  
  validates_presence_of :phone_type, :message => ''
  validates_phone :number
  
  PhoneTypes = {
    'Home'      => 'home',
    'Business'  => 'business',
    'Mobile'    => 'mobile',
    'Pager'     => 'pager'
    }
  DefaultPhoneType = PhoneTypes['Home']
  
  def to_s
    num = phone_type + ': '
    num = "+#{prefix} " unless prefix.empty?
    num += "#{area_code} #{number} "
    num += "ext: #{extension}" unless extension.empty?
    num
  end
end
