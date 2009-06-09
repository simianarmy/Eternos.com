# $Id$

# Used by backup message queues to transfer backup job information

class BackupJobMessage
  attr_reader :sites
  
  def payload(member)
    @sites = member.backup_sources.confirmed.collect do |site| 
      {:id => site.id, :source => site.backup_site.name}
    end
    {:user_id => member.id, :target_sites => sites}.to_yaml
  end
end
