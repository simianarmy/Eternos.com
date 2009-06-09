class Session < ActiveRecord::Base
  cattr_accessor :loader
  self.loader = 'users'
end
