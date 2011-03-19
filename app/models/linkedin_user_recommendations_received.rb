class LinkedinUserRecommendationsReceived < ActiveRecord::Base
  belongs_to :linkedin_user

  def process_hash(recommendations_received)
    if (recommendations_received.nil?)
      return nil
    end
    recommendations_received['linkedin_id']  = recommendations_received['recommender'].delete('id')
    recommendations_received['last_name'] = recommendations_received['recommender'].delete('last_name')
    recommendations_received['first_name'] = recommendations_received['recommender'].delete('first_name')
    recommendations_received.delete('recommender')
    recommendations_received['recommendation_type'] = recommendations_received['recommendation_type']['code']
    recommendations_received['recommendation_id']   = recommendations_received['id']
    recommendations_received.delete('id')
    recommendations_received.delete('recommendation_type')
    return recommendations_received
  end

  def initialize(hash)
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
