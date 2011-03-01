class LinkedinUser < ActiveRecord::Base
  has_many  :linkedin_user_certifications,:class_name => "LinkedinUserCertification"
  has_many  :linkedin_user_connections, :class_name => "LinkedinUserConnection"
  has_many  :linkedin_user_educations, :class_name => "LinkedinUserEducation"
  has_many  :linkedin_user_im_accounts, :class_name => "LinkedinUserImAccount"
  has_many  :linkedin_user_languages, :class_name => "LinkedinUserLanguage"
  has_many  :linkedin_user_patents, :class_name => "LinkedinUserPatent"
  has_many  :linkedin_user_positions, :class_name => "LinkedinUserPosition"
  has_many  :linkedin_past_people_positions, :class_name => "LinkedinUserPastPosition"
  has_many  :linkedin_current_people_positions, :class_name => "LinkedinUserCurrentPosition"
  has_many  :linkedin_user_publications, :class_name => "LinkedinUserPublication"
  has_many  :linkedin_user_recommendations_receiveds, :class_name => "LinkedinUserRecommendationsReceived"
  has_many  :linkedin_user_relation_to_viewer
  has_many  :linkedin_user_skills,:class_name => "LinkedinUserSkill"
  has_many  :linkedin_user_twitter_accounts, :class_name => "LinkedinUserTwitterAccount"
  has_many  :linkedin_user_member_url_resources, :class_name => "LinkedinUserMemberUrlResource"
  has_many  :linkedin_user_current_share, :class_name => "LinkedinUserCurrentShare"
  has_many  :linkedin_user_phone_numbers, :class_name => "LinkedinUserPhoneNumber"
  has_many  :linkedin_user_comment_like, :class_name => "LinkedinUserCommentLike"
  has_many  :linkedin_user_cmpies, :class_name => "LinkedinUserCmpy"
  has_many  :linkedin_user_ncons, :class_name => "LinkedinUserNcon"

  def add_certifications_from_people(certifications)
    if certifications.nil?
      return
    end
    if Integer(certifications['total']) > 1
      certifications['certification'].each { |certification|
        li  = LinkedinUserCertification.from_certification(certification)
        linkedin_user_certifications << li
      }
    else
      li  = LinkedinUserCertification.from_certification(certifications['certification'])
      linkedin_user_certifications << li
    end
  end

  def add_skills_from_people(skills)
    if skills.nil?
      return
    end
    if Integer(skills['total']) > 1
      skills['skill'].each { |skill|
        li = LinkedinUserSkill.from_skills(skill)
        linkedin_user_skills << li     
      }
    else
      li  = LinkedinUserSkill.from_skills(skills['skill'])
      linkedin_user_skills << li
    end
  end

  def add_connections_from_people(connections)
    if connections.nil? || connections['connection'].nil?
      return
    end
    if Integer(connections['total']) > 1
      connections['connection'].each { |connection|
        li = LinkedinUserConnection.from_connections(connection)
        linkedin_user_connections << li
      }
    else
      li  = LinkedinUserConnection.from_connections(connections['connection'])
      linkedin_user_connections << li
    end
  end

  def add_educations_from_people(educations)
    if educations.nil? || educations['education'].nil?
      return
    end
    if Integer(educations['total']) > 1
      educations['education'].each { |education|
        li = LinkedinUserEducation.from_educations(education)
        linkedin_user_educations << li
      }
    else
      li  = LinkedinUserEducation.from_educations(educations['education'])
      linkedin_user_educations << li
    end
  end

  def add_im_account_from_people(im_accounts)
    if im_accounts.nil? || im_accounts['im_account'].nil?
      return
    end
    if Integer(im_accounts['total']) > 1
      im_accounts['im_account'].each { |im_account|
        li = LinkedinUserImAccount.from_im_account(im_account)
        linkedin_user_im_accounts << li
      }
    else
      li  = LinkedinUserImAccount.from_im_account(im_accounts['im_account'])
      linkedin_user_im_accounts << li
    end
  end

  def add_languages_from_people(languages)
    if languages.nil? || languages['language'].nil?
      return
    end
    if Integer(languages['total']) > 1
      languages['language'].each { |language|
        li = LinkedinUserLanguage.from_languages(language)
        linkedin_user_languages << li
      }
    else
      li  = LinkedinUserLanguage.from_languages(languages['language'])
      linkedin_user_languages << li
    end
  end

  def add_patents_from_people(patents)
    if patents.nil? || patents['patent'].nil?
      return
    end
    if Integer(patents['total']) > 1
      patents['patent'].each { |patent|
        li = LinkedinUserPatent.from_patents(patent)
        linkedin_user_patents << li
        #li.add_patent_inventors_from_people(patent.delete('inventors'),li.id)
      }
    else
      li  = LinkedinUserPatent.from_patents(patents['patent'])
      linkedin_user_patents << li
      #li.add_patent_inventors_from_people(patents['patent'].delete('inventors'),li.id)
    end
  end

  def add_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinUserPosition.from_positions(position)
        linkedin_user_positions << li
      }
    else
      li  = LinkedinUserPosition.from_positions(positions['position'])
      linkedin_user_positions << li
    end
  end
  def add_past_postions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinUserPastPosition.from_positions(position)
        linkedin_past_people_positions << li
      }
    else
      li  = LinkedinUserPastPosition.from_positions(positions['position'])
      linkedin_past_people_positions << li
    end
  end
  def add_current_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinUserCurrentPosition.from_positions(position)
        linkedin_current_people_positions << li
      }
    else
      li  = LinkedinUserCurrentPosition.from_positions(positions['position'])
      linkedin_current_people_positions << li
    end
  end

  def add_publications_from_people(publications)
    if publications.nil? || publications['publication'].nil?
      return
    end
    if Integer(publications['total']) > 1
      publications['publication'].each { |publication|
        li = LinkedinUserPublication.from_publications(publication)
        linkedin_user_publications << li
      }
    else
      li  = LinkedinUserPublication.from_publications(publications['publication'])
      linkedin_user_publications << li
    end
  end

  def add_recommendations_receiveds_from_people(recommendations)
    if recommendations.nil? || recommendations['recommendation'].nil?
      return
    end
    if Integer(recommendations['total']) > 1
      recommendations['recommendation'].each { |recommendations_received|
        li = LinkedinUserRecommendationsReceived.from_recommendations_receiveds(recommendations_received)
        linkedin_user_recommendations_receiveds << li
      }
    else
      li  = LinkedinUserRecommendationsReceived.from_recommendations_receiveds(recommendations['recommendation'])
      linkedin_user_recommendations_receiveds << li
    end
  end
  def add_twitter_accounts_from_people(twitter_accounts)
    if twitter_accounts.nil? || twitter_accounts['twitter_account'].nil?
      return
    end
    if Integer(twitter_accounts['total']) > 1
      twitter_accounts['twitter_account'].each { |twitter_account|
        li = LinkedinUserTwitterAccount.from_twitter_accounts(twitter_account)
        linkedin_user_twitter_accounts << li
      }
    else
      li  = LinkedinUserTwitterAccount.from_twitter_accounts(twitter_accounts['twitter_account'])
      linkedin_user_twitter_accounts << li
    end
  end

  def add_member_urls_from_people(member_urls)
    if member_urls.nil? || member_urls['member_url'].nil?
      return
    end
    if Integer(member_urls['total']) > 1
      member_urls['member_url'].each { |member_url|
        li = LinkedinUserMemberUrlResource.from_member_urls(member_url)
        linkedin_user_member_url_resources << li
      }
    else
      li  = LinkedinUserMemberUrlResource.from_member_urls(member_urls['member_url'])
      linkedin_user_member_url_resources << li
    end
  end
  def add_curent_share_from_people(current_share)
    if current_share.nil?
      return
    end

    li  = LinkedinUserCurrentShare.from_current_share(current_share)
    linkedin_user_current_share << li

  end

  def add_phone_numbers_from_people(phone_numbers)
    if phone_numbers.nil? || phone_numbers['phone_number'].nil?
      return
    end
    if Integer(phone_numbers['total']) > 1
      phone_numbers['phone_number'].each { |phone_number|
        li = LinkedinUserPhoneNumber.from_phone_numbers(phone_number)
        linkedin_user_phone_numbers << li
      }
    else
      li  = LinkedinUserPhoneNumber.from_phone_numbers(phone_numbers['phone_number'])
      linkedin_user_phone_numbers << li
    end
  end

  def add_comment_likes_from_people(comment_likes)
    if comment_likes.nil? || comment_likes['update'].nil?
      return
    end
    if Integer(comment_likes['total']) > 1
      comment_likes['update'].each { |comment_like|
        li = LinkedinUserCommentLike.from_comment_likes(comment_like)
        linkedin_user_comment_like << li
      }
    else
      li  = LinkedinUserCommentLike.from_comment_likes(comment_likes['update'])
      linkedin_user_comment_like << li
    end
  end

  def add_cmpy_from_people(cmpies)
    if cmpies.nil? || cmpies['update'].nil?
      return
    end
    if Integer(cmpies['total'])>1
      cmpies ['update'].each { |update|

        li = LinkedinUserCmpy.from_cmpys(update)
        linkedin_user_cmpies << li
      }
    else
      li = LinkedinUserCmpy.from_cmpys(cmpies['update'])
      linkedin_user_cmpies << li
    end
  end

  def add_ncon_from_people(ncons)
    if ncons.nil? || ncons['update'].nil?
      return
    end
    li = LinkedinUserNcon.from_ncons(ncons['update'])
    linkedin_user_ncons << li

  end
  
    
  def update_certifications_from_people(certifications,user_id)
    if certifications.nil?
      return
    end
    LinkedinUserCertification.delete(user_id)
    add_certifications_from_people(certifications)
  end

  def update_skills_from_people(skills,user_id)
    if skills.nil?
      return
    end
    LinkedinUserSkill.delete(user_id)
    add_skills_from_people(skills)
  end

  def update_connections_from_people(connections,user_id)
    if connections.nil? || connections['connection'].nil?
      return
    end
    LinkedinUserConnection.delete(user_id)
    add_connections_from_people(connections)
  end

  def update_educations_from_people(educations,user_id)
    if educations.nil? || educations['education'].nil?
      return
    end
    LinkedinUserEducation.delete(user_id)
    add_educations_from_people(educations)
  end

  def update_im_accounts_from_people(im_accounts,user_id)
    if im_accounts.nil? || im_accounts['im_account'].nil?
      return
    end
    LinkedinUserImAccount.delete(user_id)
    add_im_account_from_people(im_accounts)
  end

  def update_languages_from_people(languages,user_id)
    if languages.nil? || languages['language'].nil?
      return
    end
    LinkedinUserLanguage.delete(user_id)
    add_languages_from_people(languages)
  end

  def update_patents_from_people(patents,user_id)
    if patents.nil? || patents['patent'].nil?
      return
    end
    LinkedinUserPatent.delete(user_id)
    add_patents_from_people(patents)
  end

  def update_positions_from_people(positions,user_id)
    if positions.nil? || positions['position'].nil?
      return
    end
    LinkedinUserPosition.delete(user_id)
    add_positions_from_people(positions)
  end
  def update_past_postions_from_people(positions,user_id)
    if positions.nil? || positions['position'].nil?
      return
    end
    LinkedinUserPastPosition.delete(user_id)
    add_past_postions_from_people(positions)
  end
  def update_current_positions_from_people(positions,user_id)
    if positions.nil? || positions['position'].nil?
      return
    end
    LinkedinUserCurrentPosition.delete(user_id)
    add_current_positions_from_people(positions)
  end

  def update_publications_from_people(publications,user_id)
    if publications.nil? || publications['publication'].nil?
      return
    end
    LinkedinUserPublication.delete(user_id)
    add_publications_from_people(publications)
  end

  def update_recommendations_receiveds_from_people(recommendations,user_id)
    if recommendations.nil? || recommendations['recommendation'].nil?
      return
    end
    LinkedinUserRecommendationsReceived.delete(user_id)
    add_recommendations_receiveds_from_people(recommendations)
  end
  def update_twitter_accounts_from_people(twitter_accounts,user_id)
    if twitter_accounts.nil? || twitter_accounts['twitter_account'].nil?
      return
    end
    LinkedinUserTwitterAccount.delete(user_id)
    add_twitter_accounts_from_people(twitter_accounts)
  end

  def update_member_url_resources_from_people(member_urls,user_id)
    if member_urls.nil? || member_urls['member_url'].nil?
      return
    end
    LinkedinUserMemberUrlResource.delete(user_id)
  end
  def update_current_shares_from_people(current_share,user_id)
    if current_share.nil?
      return
    end

    LinkedinUserCurrentShare.delete(user_id)
    add_curent_share_from_people(current_share)

  end

  def update_phone_numbers_from_people(phone_numbers,user_id)
    if phone_numbers.nil? || phone_numbers['phone_number'].nil?
      return
    end
    LinkedinUserPhoneNumber.delete(user_id)
    add_phone_numbers_from_people(phone_numbers)
  end

  def update_comment_likes_from_people(comment_likes,user_id)
    if comment_likes.nil? || comment_likes['update'].nil?
      return
    end
    LinkedinUserCommentLike.delete(user_id)
    add_comment_likes_from_people(comment_likes)
  end

  def update_cmpy_from_people(cmpies,user_id)
    if cmpies.nil? || cmpies['update'].nil?
      return
    end
    LinkedinUserCmpy.delete(user_id)
    add_cmpy_from_people(cmpies)
  end

  def update_ncon_from_people(ncons,user_id)
    if ncons.nil? || ncons['update'].nil?
      return
    end
    LinkedinUserNcon.update_ncons(ncons['update'],user_id)
    add_ncon_from_people(ncons)

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
    
    people = LinkedinUser.new(@hash)
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
    people.add_cmpy_from_people(@cmpies_hash)
    people.add_ncon_from_people(@ncons_hash)
   
  end
  
  def self.update_profile(peopleprofile,comment_like, cmpies, ncons,backup_source_id)
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

    
    user = LinkedinUser.find_all_by_backup_source_id(backup_source_id).first
    user.update_attributes(@hash);
    user.save
    user.update_certifications_from_people(certifications, user.id)
    user.update_connections_from_people(connections, user.id)
    user.update_positions_from_people(positions , user.id)
    user.update_current_shares_from_people(current_share, user.id)
    user.update_educations_from_people(educations, user.id)
    user.update_im_accounts_from_people(im_accounts, user.id)
    user.update_languages_from_people(languages, user.id)
    user.update_member_url_resources_from_people(member_url_resources, user.id)
    user.update_positions_from_people(three_past_positions, user.id)
    user.update_patents_from_people(patents, user.id)
    user.update_phone_numbers_from_people(phone_numbers, user.id)
    user.update_positions_from_people(positions, user.id)
    user.update_publications_from_people(publications, user.id)
    user.update_recommendations_receiveds_from_people(recommendations_receiveds, user.id)
    user.update_skills_from_people(skills, user.id)
    user.update_twitter_accounts_from_people(twitter_accounts, user.id)
    user.update_current_positions_from_people(three_current_positions, user.id)

    user.update_comment_likes_from_people(@comment_like_hash)
    user.update_cmpy_from_people(@cmpies_hash)
    user.update_ncon_from_people(@ncons_hash)

  end

end
