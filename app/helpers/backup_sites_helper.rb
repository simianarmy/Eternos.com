# $Id$

module BackupSitesHelper
  # returns backup icon image tag
  # dims => dimensions string
  # example: 36x36
  def backup_icon(name, dims)
    image_tag "icons/#{name}-48.png", :size => dims
  end
end
