class Session < ActiveRecord::Base
  cattr_accessor :loader
  self.loader = 'app'
end
