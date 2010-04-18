# $Id$

class RawText < ActiveRecord::Base
  belongs_to :user
  serialize :word_counts
end
