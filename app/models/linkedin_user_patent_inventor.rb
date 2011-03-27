class LinkedinUserPatentInventor < ActiveRecord::Base
  belongs_to :linkedin_user_patents,:foreign_key => "linkedin_user_patents_id"

   def process_hash(author)
    if (author.nil?)
      return nil
    end
   author['linkedin_id'] = author.delete('id')
   
    return author
  end

  def initialize(hash)
    print "aaaaa:"
    print hash.inspect
    hash = process_hash(hash)
    super(hash)

  end

  def compare_hash(hash_from_database,hash_from_server)
    result = Hash.new
    hash_from_database.each { |key,value|
      if key.to_s != 'linkedin_user_id'.to_s && key.to_s != 'created_at'.to_s && key.to_s != 'updated_at'.to_s && value != hash_from_server[key]
        result[key] = hash_from_server[key]
      end
    }
    return result
  end


  def update_attributes(hash)
    hash = process_hash(hash)
    hash = compare_hash(self.attributes,hash)
    super(hash)
  end
end
