# $Id$

# Used by backup message queues to transfer backup job information

class BackupJobMessage
  attr_reader :sites
  
  # Returns payload object for a member - includes multiple backup sources
  def member_payload(member)
    sources = member.backup_sources.confirmed.map {|source| source_to_h(source)}
    payload(member, sources)
  end
  
  # Returns payload object a backup source (1 member)
  def source_payload(source)
    payload(source.member, [source_to_h(source)])
  end
  
  private
  
  def source_to_h(source)
    {:id => source.id, :source => source.backup_site.type_name}
  end
  
  def payload(member, sources)
    {:user_id => member.id, :target_sites => sources}.to_yaml
  end
end
