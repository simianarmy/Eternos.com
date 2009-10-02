# $Id$
class ActiveRecord::Base
  TagSeparator = ','
  
  def tag_with(tags, user)
    tag_list.downcase.split(TagSeparator).each do |tag|
      begin
        t = Tag.find_or_create_by_name(tag)
        Tagging.create(:tag => t, 
          :taggable => self, :tagger => user)
      rescue ActiveRecord::StatementInvalid => e
        raise unless e.to_s[/Duplicate entry/]
      end    
    end
  end
  #alias tag_list= tag_with
  
  def tag_list
    tags.map(&:name).join(TagSeparator)
  end
  
  def tag_delete tag_string
    split = tag_string.split(TagSeparator)
    tags.delete tags.select{|t| split.include? t.name}
  end
  
end
