# $Id$

class AvAttachment < ActiveRecord::Base
  belongs_to :av_attachable, :polymorphic => true
  belongs_to :recording
end