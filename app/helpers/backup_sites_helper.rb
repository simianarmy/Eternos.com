# $Id$

module BackupSitesHelper
  # returns backup icon image tag
  # dims => dimensions string
  # example: 36x36
  def backup_icon(name, dims, active=false)
    icon = active ? "#{name}-active.gif" : "#{name}-noactive.gif"
    image_tag "icons/#{icon}", :size => dims
  end
end
