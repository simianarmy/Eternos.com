class LinkedinPeople < ActiveRecord::Base
  has_many  :linkedin_people_certifications,:class_name => "LinkedinPeopleCertifications"
  has_many  :linkedin_people_connections, :class_name => "LinkedinPeopleConnections"
  has_many  :linkedin_people_educations, :class_name => "LinkedinPeopleEducations"
  has_many  :linkedin_people_im_accounts, :class_name => "LinkedinPeopleImAccount"
  has_many  :linkedin_people_languages, :class_name => "LinkedinPeopleLanguages"
  has_many  :linkedin_people_patents, :class_name => "LinkedinPeoplePatents"
  has_many  :linkedin_people_positions, :class_name => "LinkedinPeoplePositions"
  has_many  :linkedin_past_people_positions, :class_name => "LinkedinPeoplePastPositions"
  has_many  :linkedin_current_people_positions, :class_name => "LinkedinPeopleCurrentPositions"
  has_many  :linkedin_people_publications, :class_name => "LinkedinPeoplePublications"
  has_many  :linkedin_people_recommendations_receiveds, :class_name => "LinkedinPeopleRecommendationsReceiveds"
  has_many  :linkedin_people_relation_to_viewer
  has_many  :linkedin_people_skills,:class_name => "LinkedinPeopleSkills"
  has_many  :linkedin_people_twitter_accounts, :class_name => "LinkedinPeopleTwitterAccount"
  has_many  :linkedin_people_member_url_resources, :class_name => "LinkedinPeopleMemberUrlResources"
  has_many  :linkedin_people_current_share, :class_name => "LinkedinPeopleCurrentShare"
  has_many  :linkedin_people_phone_numbers, :class_name => "LinkedinPeoplePhoneNumbers"
  has_many  :linkedin_people_comment_like, :class_name => "LinkedinPeopleCommentLike"
  has_many  :linkedin_people_cmpies, :class_name => "LinkedinPeopleCmpy"
  has_many  :linkedin_people_ncons, :class_name => "LinkedinPeopleNcons"

  def add_certifications_from_people(certifications)
    if certifications.nil?
      return
    end
    if Integer(certifications['total']) > 1
      certifications['certification'].each { |certification|
        li  = LinkedinPeopleCertifications.from_certification(certification)
        linkedin_people_certifications << li
      }
    else
      li  = LinkedinPeopleCertifications.from_certification(certifications['certification'])
      linkedin_people_certifications << li
    end
  end

  def add_skills_from_people(skills)
    if skills.nil?
      return
    end
    if Integer(skills['total']) > 1
      skills['skill'].each { |skill|
        li = LinkedinPeopleSkills.from_skills(skill)
        linkedin_people_skills << li     
      }
    else
      li  = LinkedinPeopleSkills.from_skills(skills['skill'])
      linkedin_people_skills << li
    end
  end

  def add_connections_from_people(connections)
    if connections.nil? || connections['connection'].nil?
      return
    end
    if Integer(connections['total']) > 1
      connections['connection'].each { |connection|
        li = LinkedinPeopleConnections.from_connections(connection)
        linkedin_people_connections << li
      }
    else
      li  = LinkedinPeopleConnections.from_connections(connections['connection'])
      linkedin_people_connections << li
    end
  end

  def add_educations_from_people(educations)
    if educations.nil? || educations['education'].nil?
      return
    end
    if Integer(educations['total']) > 1
      educations['education'].each { |education|
        li = LinkedinPeopleEducations.from_educations(education)
        linkedin_people_educations << li
      }
    else
      li  = LinkedinPeopleEducations.from_educations(educations['education'])
      linkedin_people_educations << li
    end
  end

  def add_im_account_from_people(im_accounts)
    if im_accounts.nil? || im_accounts['im_account'].nil?
      return
    end
    if Integer(im_accounts['total']) > 1
      im_accounts['im_account'].each { |im_account|
        li = LinkedinPeopleImAccount.from_im_account(im_account)
        linkedin_people_im_accounts << li
      }
    else
      li  = LinkedinPeopleImAccount.from_im_account(im_accounts['im_account'])
      linkedin_people_im_accounts << li
    end
  end

  def add_languages_from_people(languages)
    if languages.nil? || languages['language'].nil?
      return
    end
    if Integer(languages['total']) > 1
      languages['language'].each { |language|
        li = LinkedinPeopleLanguages.from_languages(language)
        linkedin_people_languages << li
      }
    else
      li  = LinkedinPeopleLanguages.from_languages(languages['language'])
      linkedin_people_languages << li
    end
  end

  def add_patents_from_people(patents)
    if patents.nil? || patents['patent'].nil?
      return
    end
    if Integer(patents['total']) > 1
      patents['patent'].each { |patent|
        li = LinkedinPeoplePatents.from_patents(patent)
        linkedin_people_patents << li
      }
    else
      li  = LinkedinPeoplePatents.from_patents(patents['patent'])
      linkedin_people_patents << li
    end
  end

  def add_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinPeoplePositions.from_positions(position)
        linkedin_people_positions << li
      }
    else
      li  = LinkedinPeoplePositions.from_positions(positions['position'])
      linkedin_people_positions << li
    end
  end
  def add_past_postions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinPeoplePastPositions.from_positions(position)
        linkedin_past_people_positions << li
      }
    else
      li  = LinkedinPeoplePastPositions.from_positions(positions['position'])
      linkedin_past_people_positions << li
    end
  end
  def add_current_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinPeopleCurrentPositions.from_positions(position)
        linkedin_current_people_positions << li
      }
    else
      li  = LinkedinPeopleCurrentPositions.from_positions(positions['position'])
      linkedin_current_people_positions << li
    end
  end

  def add_publications_from_people(publications)
    if publications.nil? || publications['publication'].nil?
      return
    end
    if Integer(publications['total']) > 1
      publications['publication'].each { |publication|
        li = LinkedinPeoplePublications.from_publications(publication)
        linkedin_people_publications << li
      }
    else
      li  = LinkedinPeoplePublications.from_publications(publications['publication'])
      linkedin_people_publications << li
    end
  end

  def add_recommendations_receiveds_from_people(recommendations)
    if recommendations.nil? || recommendations['recommendation'].nil?
      return
    end
    if Integer(recommendations['total']) > 1
      recommendations['recommendation'].each { |recommendations_received|
        li = LinkedinPeopleRecommendationsReceiveds.from_recommendations_receiveds(recommendations_received)
        linkedin_people_recommendations_receiveds << li
      }
    else
      li  = LinkedinPeopleRecommendationsReceiveds.from_recommendations_receiveds(recommendations['recommendation'])
      linkedin_people_recommendations_receiveds << li
    end
  end
  def add_twitter_accounts_from_people(twitter_accounts)
    if twitter_accounts.nil? || twitter_accounts['twitter_account'].nil?
      return
    end
    if Integer(twitter_accounts['total']) > 1
      twitter_accounts['twitter_account'].each { |twitter_account|
        li = LinkedinPeopleTwitterAccount.from_twitter_accounts(twitter_account)
        linkedin_people_twitter_accounts << li
      }
    else
      li  = LinkedinPeopleTwitterAccount.from_twitter_accounts(twitter_accounts['twitter_account'])
      linkedin_people_twitter_accounts << li
    end
  end

  def add_member_urls_from_people(member_urls)
    if member_urls.nil? || member_urls['member_url'].nil?
      return
    end
    if Integer(member_urls['total']) > 1
      member_urls['member_url'].each { |member_url|
        li = LinkedinPeopleMemberUrlResources.from_member_urls(member_url)
        linkedin_people_member_url_resources << li
      }
    else
      li  = LinkedinPeopleMemberUrlResources.from_member_urls(member_urls['member_url'])
      linkedin_people_member_url_resources << li
    end
  end
  def add_curent_share_from_people(current_share)
    if current_share.nil?
      return
    end

    li  = LinkedinPeopleCurrentShare.from_current_share(current_share)
    linkedin_people_current_share << li

  end

  def add_phone_numbers_from_people(phone_numbers)
    if phone_numbers.nil? || phone_numbers['phone_number'].nil?
      return
    end
    if Integer(phone_numbers['total']) > 1
      phone_numbers['phone_number'].each { |phone_number|
        li = LinkedinPeoplePhoneNumbers.from_phone_numbers(phone_number)
        linkedin_people_phone_numbers << li
      }
    else
      li  = LinkedinPeoplePhoneNumbers.from_phone_numbers(phone_numbers['phone_number'])
      linkedin_people_phone_numbers << li
    end
  end

  def add_comment_likes_from_people(comment_likes)
    if comment_likes.nil? || comment_likes['update'].nil?
      return
    end
    if Integer(comment_likes['total']) > 1
      comment_likes['update'].each { |comment_like|
        li = LinkedinPeopleCommentLike.from_comment_likes(comment_like)
        linkedin_people_comment_like << li
      }
    else
      li  = LinkedinPeopleCommentLike.from_comment_likes(comment_likes['update'])
      linkedin_people_comment_like << li
    end
  end

  def add_CMPY_from_people(cmpies)
    if cmpies.nil? || cmpies['update'].nil?
      return
    end
    if Integer(cmpies['total'])>1
      cmpies ['update'].each { |update|

        li = LinkedinPeopleCmpy.from_cmpys(update)
        linkedin_people_cmpies << li
      }
    else
      li = LinkedinPeopleCmpy.from_cmpys(cmpies['update'])
      linkedin_people_cmpies << li
    end
  end

  def add_NCON_from_people(ncons)
    if ncons.nil? || ncons['update'].nil?
      return
    end
    li = LinkedinPeopleNcons.from_ncons(ncons['update'])
    linkedin_people_ncons << li

  end

  def self.insert (peopleprofile,comment_like, cmpies, ncons, backup_source_id)
 
    @hash = (Hash.from_xml peopleprofile)['person']
    if !comment_like.nil?
	    @comment_like_hash = (Hash.from_xml comment_like)['updates']
    end

    if !cmpies.nil?
	    @cmpies_hash = (Hash.from_xml cmpies)['updates']
    end

    if !ncons.nil?
      @ncons_hash = Hash.from_xml ncons 
    end
    #change key 'id' to 'linkedin_id'
    if !@hash['id'].nil?
      @hash['linkedin_id'] = @hash['id']
      @hash.delete('id')
    end

    if !@hash['im_accounts'].nil?
      im_accounts = @hash.delete('im_accounts')
    end

    if !@hash['location'].nil?
      location = @hash.delete('location')
    end
    if !@hash['positions'].nil?
      positions = @hash.delete('positions')
    end
    if !@hash['educations'].nil?
      educations = @hash.delete('educations')
    end
    if !@hash['three_current_positions'].nil?
      three_current_positions = @hash.delete('three_current_positions')
    end
    if !@hash['three_past_positions'].nil?
      three_past_positions = @hash.delete('three_past_positions')
    end
    if !@hash['recommendations_received'].nil?
      recommendations_receiveds = @hash.delete('recommendations_received')
    end

    if !@hash['member_url_resources'].nil?
      member_url_resources = @hash.delete('member_url_resources')
    end
    if !@hash['relation_to_viewer'].nil?
      @hash.delete('relation_to_viewer')
    end
    if !@hash['date_of_birth'].nil?
      date_of_birth = @hash.delete('date_of_birth')
    end
    if !@hash['connections'].nil?
      connections = @hash.delete('connections')
    end
    if !@hash['current_share'].nil?
      current_share = @hash.delete('current_share')
    end
    if !@hash['phone_numbers'].nil?
      phone_numbers = @hash.delete('phone_numbers')
    end
    if !@hash['twitter_accounts'].nil?
      twitter_accounts = @hash.delete('twitter_accounts')
    end
    if !@hash['skills'].nil?
      skills = @hash.delete('skills')
    end

    if !@hash['patents'].nil?
      patents = @hash.delete('patents')
    end

    if !@hash['certifications'].nil?
      certifications = @hash.delete('certifications')
    end


    if !@hash['languages'].nil?
      languages = @hash.delete('languages')
    end



    if !@hash['publications'].nil?
      publications = @hash.delete('publications')
    end
    @hash['current_status_timestamp'] = Time.at(Integer(@hash['current_status_timestamp']) / 1000)
    @hash['location_code']  = location['country']['code']
    @hash['backup_source_id'] = backup_source_id
    if !@hash['date_of_birth'].nil?
      @hash['date_of_birth'] = date_of_birth['year'] + '-' + date_of_birth['month'] + '-' + date_of_birth['day']
    end
    
    connections['total'] = @hash['num_connections']
    connections['connection'] = connections['person']
    
    people = LinkedinPeople.new(@hash)
    people.save
    people.add_skills_from_people(skills)
    people.add_certifications_from_people(certifications)
    people.add_connections_from_people(connections)
    people.add_past_postions_from_people(three_past_positions)
    people.add_current_positions_from_people(three_current_positions)
    people.add_educations_from_people(educations)
    people.add_im_account_from_people(im_accounts)
    people.add_languages_from_people(languages)
    people.add_patents_from_people(patents)
    people.add_positions_from_people(positions)
    people.add_publications_from_people(publications)
    people.add_recommendations_receiveds_from_people(recommendations_receiveds)
    people.add_twitter_accounts_from_people(twitter_accounts)
    people.add_member_urls_from_people(member_url_resources)
    people.add_curent_share_from_people(current_share)
    people.add_phone_numbers_from_people(phone_numbers)
    people.add_comment_likes_from_people(@comment_like_hash)
    people.add_CMPY_from_people(@cmpies_hash)
    people.add_NCON_from_people(@ncons_hash)

    
    twitter_accounts['twitter_account']
    
  end

end
