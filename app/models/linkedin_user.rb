class LinkedinUser < ActiveRecord::Base
  belongs_to :linkedin_account
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
  has_many  :linkedin_user_comment_likes, :class_name => "LinkedinUserCommentLike"
  has_many  :linkedin_user_cmpies, :class_name => "LinkedinUserCmpy"
  has_many  :linkedin_user_ncons, :class_name => "LinkedinUserNcon"

  def add_certifications_from_people(certifications)
    if certifications.nil?
      return
    end
    if Integer(certifications['total']) > 1

      certifications['certification'].each { |certification|
        li  = LinkedinUserCertification.new(certification)
        linkedin_user_certifications << li
      }
    else
      li  = LinkedinUserCertification.new(certifications['certification'])
      linkedin_user_certifications << li
    end
  end

  def add_skills_from_people(skills)
    if skills.nil?
      return
    end
    if Integer(skills['total']) > 1

      skills['skill'].each { |skill|
        li  = LinkedinUserSkill.new(skill)
        linkedin_user_skills << li
      }
    else
      li  = LinkedinUserSkill.new(skills['skill'])
      linkedin_user_skills << li
    end
  end

  def add_connections_from_people(connections)
    if connections.nil? || connections['connection'].nil?
      return
    end
    if Integer(connections['total']) > 1
      connections['connection'].each { |connection|
        li = LinkedinUserConnection.new(connection)
        linkedin_user_connections << li
      }
    else
      li  = LinkedinUserConnection.new(connections['connection'])
      linkedin_user_connections << li
    end
  end

  def add_educations_from_people(educations)
    if educations.nil? || educations['education'].nil?
      return
    end
    if Integer(educations['total']) > 1
      educations['education'].each { |education|
        li = LinkedinUserEducation.new(education)
        linkedin_user_educations << li
      }
    else
      li  = LinkedinUserEducation.new(educations['education'])
      linkedin_user_educations << li
    end
  end

  def add_im_account_from_people(im_accounts)
    if im_accounts.nil? || im_accounts['im_account'].nil?
      return
    end
    if Integer(im_accounts['total']) > 1
      im_accounts['im_account'].each { |im_account|
        li = LinkedinUserImAccount.new(im_account)
        linkedin_user_im_accounts << li
      }
    else
      li  = LinkedinUserImAccount.new(im_accounts['im_account'])
      linkedin_user_im_accounts << li
    end
  end

  def add_languages_from_people(languages)
    if languages.nil? || languages['language'].nil?
      return
    end
    if Integer(languages['total']) > 1
      languages['language'].each { |language|
        li = LinkedinUserLanguage.new(language)
        linkedin_user_languages << li
      }
    else
      li  = LinkedinUserLanguage.new(languages['language'])
      linkedin_user_languages << li
    end
  end

  def add_patents_from_people(patents)
    if patents.nil? || patents['patent'].nil?
      return
    end

    if Integer(patents['total']) > 1
      patents['patent'].each { |patent|
        inventors = patent['inventors']
        li = LinkedinUserPatent.new(patent)
        linkedin_user_patents << li
        li.add_patent_inventors_from_people(inventors)
      }
    else
      inventors = patents['patent']['inventors']
      li  = LinkedinUserPatent.new(patents['patent'])
      linkedin_user_patents << li
      li.add_patent_inventors_from_people(inventors)
    end
  end

  def add_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinUserPosition.new(position)
        linkedin_user_positions << li
      }
    else
      li  = LinkedinUserPosition.new(positions['position'])
      linkedin_user_positions << li
    end
  end
  def add_past_postions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinUserPastPosition.new(position)
        linkedin_past_people_positions << li
      }
    else
      li  = LinkedinUserPastPosition.new(positions['position'])
      linkedin_past_people_positions << li
    end
  end
  def add_current_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = LinkedinUserCurrentPosition.new(position)
        linkedin_current_people_positions << li
      }
    else
      li  = LinkedinUserCurrentPosition.new(positions['position'])
      linkedin_current_people_positions << li
    end
  end

  def add_publications_from_people(publications)
    if publications.nil? || publications['publication'].nil?
      return
    end

    if Integer(publications['total']) > 1
      publications['publication'].each { |publication|
        authors = publication['authors']
        li = LinkedinUserPublication.new(publication)
        linkedin_user_publications << li
        li_temp = LinkedinUserPublication.find(li.id)   
        li_temp.add_publication_authors_from_people(authors)
      }
    else
      authors = publication['authors']
      li  = LinkedinUserPublication.new(publications['publication'])
      linkedin_user_publications << li
      li_temp = LinkedinUserPublication.find(li.id)   
      li_temp.add_publication_authors_from_people(authors)
    end
  end

  def add_recommendations_receiveds_from_people(recommendations)
    if recommendations.nil? || recommendations['recommendation'].nil?
      return
    end
    if Integer(recommendations['total']) > 1
      recommendations['recommendation'].each { |recommendations_received|
        li = LinkedinUserRecommendationsReceived.new(recommendations_received)
        linkedin_user_recommendations_receiveds << li
      }
    else
      li  = LinkedinUserRecommendationsReceived.new(recommendations['recommendation'])
      linkedin_user_recommendations_receiveds << li
    end
  end
  def add_twitter_accounts_from_people(twitter_accounts)
    if twitter_accounts.nil? || twitter_accounts['twitter_account'].nil?
      return
    end
    if Integer(twitter_accounts['total']) > 1
      twitter_accounts['twitter_account'].each { |twitter_account|
        li = LinkedinUserTwitterAccount.new(twitter_account)
        linkedin_user_twitter_accounts << li
      }
    else
      li  = LinkedinUserTwitterAccount.new(twitter_accounts['twitter_account'])
      linkedin_user_twitter_accounts << li
    end
  end

  def add_member_urls_from_people(member_urls)
    if member_urls.nil? || member_urls['member_url'].nil?
      return
    end
    if Integer(member_urls['total']) > 1
      member_urls['member_url'].each { |member_url|
        li = LinkedinUserMemberUrlResource.new(member_url)
        linkedin_user_member_url_resources << li
      }
    else
      li  = LinkedinUserMemberUrlResource.new(member_urls['member_url'])
      linkedin_user_member_url_resources << li
    end
  end
  def add_curent_share_from_people(current_share)
    if current_share.nil?
      return
    end

    li  = LinkedinUserCurrentShare.new(current_share)
    linkedin_user_current_share << li

  end

  def add_phone_numbers_from_people(phone_numbers)
    if phone_numbers.nil? || phone_numbers['phone_number'].nil?
      return
    end
    if Integer(phone_numbers['total']) > 1
      phone_numbers['phone_number'].each { |phone_number|
        li = LinkedinUserPhoneNumber.new(phone_number)
        linkedin_user_phone_numbers << li
      }
    else
      li  = LinkedinUserPhoneNumber.new(phone_numbers['phone_number'])
      linkedin_user_phone_numbers << li
    end
  end

  def add_comment_likes_from_people(comment_likes)
    if comment_likes.nil? || comment_likes['update'].nil?
      return
    end
    if Integer(comment_likes['total']) > 1
      comment_likes['update'].each { |comment_like|
        li = LinkedinUserCommentLike.new(comment_like)
        linkedin_user_comment_likes << li
      }
    else
      li  = LinkedinUserCommentLike.new(comment_likes['update'])
      linkedin_user_comment_likes << li
    end
  end

  def add_cmpy_from_people(cmpies)
    if cmpies.nil? || cmpies['update'].nil?
      return
    end
    if Integer(cmpies['total'])>1
      cmpies ['update'].each { |update|

        li = LinkedinUserCmpy.new(update)
        linkedin_user_cmpies << li
      }
    else
      li = LinkedinUserCmpy.new(cmpies['update'])
      linkedin_user_cmpies << li
    end
  end

  def add_ncon_from_people(ncons)
    if ncons.nil? || ncons['updates'].nil?
      return
    end
    #RAILS_DEFAULT_LOGGER.info "#{ncons.inspect}"
    li = LinkedinUserNcon.new(ncons['update'])

    linkedin_user_ncons << li
  end

  def update_certifications_from_people(certifications)
    if certifications.nil?
      return
    end

    if Integer(certifications['total']) > 1

      certifications['certification'].each { |certification|
        certifications_record = LinkedinUserCertification.find_all_by_certification_id_and_linkedin_user_id(certification['id'],self.id).first
        if (certifications_record.nil?)
          li  = LinkedinUserCertification.new(certification)
          linkedin_user_certifications << li
        else
          certifications_record.update_attributes(certification)
        end

      }
    else
      certification = certifications['certification']
      certifications_record = LinkedinUserCertification.find_all_by_certification_id_and_linkedin_user_id(certification['id'],self.id).first
      if (certifications_record.nil?)
        li  = LinkedinUserCertification.new(certification)
        linkedin_user_certifications << li
      else
        certifications_record.update_attributes(certification)
      end
    end
  end

  def update_skills_from_people(skills)
    if skills.nil?
      return
    end

    if Integer(skills['total']) > 1

      skills['skill'].each { |skill|
        skills_record = LinkedinUserSkill.find_all_by_skill_id_and_linkedin_user_id(skill['id'],self.id).first
        if (skills_record.nil?)
          li  = LinkedinUserSkill.new(skill)
          linkedin_user_skills << li
        else
          skills_record.update_attributes(skill)
        end

      }
    else
      skill = skills['skill']
      skills_record = LinkedinUserSkill.find_all_by_skill_id_and_linkedin_user_id(skill['id'],self.id).first
      if (skills_record.nil?)
        li  = LinkedinUserSkill.new(skill)
        linkedin_user_skills << li
      else
        skills_record.update_attributes(skills['skill'])
      end	

    end
  end

  def update_connections_from_people(connections)
    if connections.nil? || connections['connection'].nil?
      return
    end

    if Integer(connections['total']) > 1

      connections['connection'].each { |connection|
        connections_record = LinkedinUserConnection.find_all_by_linkedin_id_and_linkedin_user_id(connection['id'],self.id).first
        if (connections_record.nil?)
          li  = LinkedinUserConnection.new(connection)
          linkedin_user_connections << li
        else
          connections_record.update_attributes(connection)
        end

      }
    else
      connections_record = LinkedinUserConnection.find_all_by_linkedin_id_and_linkedin_user_id(connections['connection']['id'],self.id).first
      if (connections_record.nil?)
        li  = LinkedinUserConnection.new(connection)
        linkedin_user_connections << li
      else
        connections_record.update_attributes(connections['connection'])
      end	
    end
  end

  def update_educations_from_people(educations)
    if educations.nil? || educations['education'].nil?
      return
    end

    if Integer(educations['total']) > 1

      educations['education'].each { |education|
        educations_record = LinkedinUserEducation.find_all_by_education_id_and_linkedin_user_id(education['id'],self.id).first
        if (educations_record.nil?)
          li  = LinkedinUserEducation.new(education)
          linkedin_user_educations << li
        else
          educations_record.update_attributes(education)
        end

      }
    else
      educations_record = LinkedinUserEducation.find_all_by_education_id_and_linkedin_user_id(educations['education']['id'],self.id).first
      if (educations_record.nil?)
        li  = LinkedinUserEducation.new(education)
        linkedin_user_educations << li
      else
        educations_record.update_attributes(educations['education'])
      end

    end
  end

  def update_im_accounts_from_people(im_accounts)
    if im_accounts.nil? || im_accounts['im_account'].nil?
      return
    end

    if Integer(im_accounts['total']) > 1

      im_accounts['im_account'].each { |im_account|
        im_accounts_record = LinkedinUserImAccount.find_all_by_linkedin_user_id(self.id).first
        if (im_accounts_record.nil?)
          li  = LinkedinUserImAccount.new(im_account)
          linkedin_user_im_accounts << li
        else
          im_accounts_record.update_attributes(im_account)
        end

      }
    else
      im_accounts_record = LinkedinUserImAccount.find_all_by_linkedin_user_id(self.id).first
      if (im_accounts_record.nil?)
        li  = LinkedinUserImAccount.new(im_account)
        linkedin_user_im_accounts << li
      else
        im_accounts_record.update_attributes(im_accounts['im_account'])
      end

    end
  end

  def update_languages_from_people(languages)
    if languages.nil? || languages['language'].nil?
      return
    end

    if Integer(languages['total']) > 1

      languages['language'].each { |language|
        languages_record = LinkedinUserLanguage.find_all_by_language_id_and_linkedin_user_id(language['id'],self.id).first
        if (languages_record.nil?)
          li  = LinkedinUserLanguage.new(language)
          linkedin_user_languages << li
        else
          languages_record.update_attributes(language)
        end

      }
    else
      languages_record = LinkedinUserLanguage.find_all_by_language_id_and_linkedin_user_id(languages['language']['id'],self.id).first
      if (languages_record.nil?)
        li  = LinkedinUserLanguage.new(language)
        linkedin_user_languages << li
      else
        languages_record.update_attributes(languages['language'])
      end

    end
  end

  def update_patents_from_people(patents)
    if patents.nil? || patents['patent'].nil?
      return
    end

    if Integer(patents['total']) > 1

      patents['patent'].each { |patent|
        patents_record = LinkedinUserPatent.find_all_by_patent_id_and_linkedin_user_id(patent['id'],self.id).first
        if (patents_record.nil?)
          li  = LinkedinUserPatent.new(patent)
          linkedin_user_patents << li
        else
          patents_record.update_attributes(patent)
        end

      }
    else
      patents_record = LinkedinUserPatent.find_all_by_patent_id_and_linkedin_user_id(patents['patent']['id'],self.id).first
      if (patents_record.nil?)
        li  = LinkedinUserPatent.new(patent)
        linkedin_user_patents << li
      else
        patents_record.update_attributes(patents['patent'])
      end

    end
  end

  def update_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end

    if Integer(positions['total']) > 1

      positions['position'].each { |position|
        positions_record = LinkedinUserPosition.find_all_by_position_id_and_linkedin_user_id(position['id'],self.id).first

        if (positions_record.nil?)
          li  = LinkedinUserPosition.new(position)
          linkedin_user_positions << li
        else

          positions_record.update_attributes(position)
        end

      }
    else
      positions_record = LinkedinUserPosition.find_all_by_position_id_and_linkedin_user_id(positions['position']['id'],self.id).first
      if (positions_record.nil?)
        li  = LinkedinUserPosition.new(position)
        linkedin_user_positions << li
      else

        positions_record.update_attributes(positions['position'])
      end

    end
  end

  def update_past_postions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end

    LinkedinUserPastPosition.delete(self.id)
    add_past_positions_from_people(positions)	
  end

  def update_current_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end

    LinkedinUserCurrentPosition.delete(self.id)
    add_current_positions_from_people(positions)
  end

  def update_publications_from_people(publications)
    if publications.nil? || publications['publication'].nil?
      return
    end

    if Integer(publications['total']) > 1

      publications['publication'].each { |publication|
        publications_record = LinkedinUserPublication.find_all_by_publication_id_and_linkedin_user_id(publication['id'],self.id).first
        if (publications_record.nil?)
          li  = LinkedinUserPublication.new(publication)
          linkedin_user_publications << li
        else
          publications_record = LinkedinUserPublication.find_all_by_linkedin_user_id(self.id).first
          publications_record.update_attributes(publication)
        end
      }
    else
      publications_record = LinkedinUserPublication.find_all_by_publication_id_and_linkedin_user_id(publications['publication']['id'],self.id).first
      if (publications_record.nil?)
        li  = LinkedinUserPublication.new(publication)
        linkedin_user_publications << li
      else
        publications_record.update_attributes(publications['publication'])
      end
    end
  end


  def update_recommendations_receiveds_from_people(recommendations)
    if recommendations.nil? || recommendations['recommendation'].nil?
      return
    end
    if Integer(recommendations['total']) > 1

      recommendations['recommendations'].each { |recommendation|
        recommendations_receiveds_record = LinkedinUserRecommendationsReceived.find_all_by_recommendation_id_and_linkedin_user_id(recommendation['id'],self.id).first
        if (recommendations_receiveds_record.nil?)
          li  = LinkedinUserRecommendationsReceived.new(recommendation)
          linkedin_user_recommendations_receiveds << li
        else

          recommendations_receiveds_record.update_attributes(recommendation)
        end

      }
    else
      recommendations_receiveds_record = LinkedinUserRecommendationsReceived.find_all_by_recommendation_id_and_linkedin_user_id(recommendations['recommendation']['id'],self.id).first
      if (recommendations_receiveds_record.nil?)
        li  = LinkedinUserRecommendationsReceived.new(recommendation)
        linkedin_user_recommendations_receiveds << li
      else

        recommendations_receiveds_record.update_attributes(recommendations['recommendation'])
      end

    end
  end
  def update_twitter_accounts_from_people(twitter_accounts)
    if twitter_accounts.nil? || twitter_accounts['twitter_account'].nil?
      return
    end
    if Integer(twitter_accounts['total']) > 1

      twitter_accounts['twitter_account'].each { |twitter_account|
        twitter_accounts_record = LinkedinUserTwitterAccount.find_all_by_linkedin_user_id(self.id).first
        if (twitter_accounts_record.nil?)
          li  = LinkedinUserTwitterAccount.new(twitter_account)
          linkedin_user_twitter_accounts << li
        else
          twitter_accounts_record.update_attributes(twitter_account)
        end

      }
    else
      twitter_accounts_record = LinkedinUserTwitterAccount.find_all_by_linkedin_user_id(self.id).first
      if (twitter_accounts_record.nil?)
        li  = LinkedinUserTwitterAccount.new(twitter_account)
        linkedin_user_twitter_accounts << li
      else
        twitter_accounts_record.update_attributes(twitter_accounts['twitter_account'])
      end

    end
  end


  def update_member_url_resources_from_people(member_urls)
    if member_urls.nil? || member_urls['member_url'].nil?
      return
    end
    LinkedinUserMemberUrlResource.delete(self.id)
    add_member_urls_from_people(member_urls)
  end

  def update_current_shares_from_people(current_share)
    if current_share.nil?
      return
    end

    current_shares_record = LinkedinUserCurrentShare.find_all_by_linkedin_user_id(self.id).first
    current_shares_record.update_attributes(current_share)


  end

  def update_phone_numbers_from_people(phone_numbers)
    if phone_numbers.nil? || phone_numbers['phone_number'].nil?
      return
    end
    if Integer(phone_numbers['total']) > 1

      phone_numbers['phone_number'].each { |phone_number|
        phone_numbers_record = LinkedinUserPhoneNumber.find_all_by_linkedin_user_id(self.id).first
        if (phone_numbers_record.nil?)
          li  = LinkedinUserPhoneNumber.new(phone_number)
          linkedin_user_phone_numbers << li
        else
          phone_numbers_record.update_attributes(phone_number)
        end

      }
    else
      phone_numbers_record = LinkedinUserPhoneNumber.find_all_by_linkedin_user_id(self.id).first
      if (phone_numbers_record.nil?)
        li  = LinkedinUserPhoneNumber.new(phone_number)
        linkedin_user_phone_numbers << li
      else
        phone_numbers_record.update_attributes(phone_numbers['phone_number'])
      end


    end
  end

  def update_comment_likes_from_people(comment_likes)
    if comment_likes.nil? || comment_likes['update'].nil?
      return
    end

    if Integer(comment_likes['total']) > 1

      comment_likes['update'].each { |comment_like|
        comment_likes_record = LinkedinUserCommentLike.find_all_by_linkedin_id_and_linkedin_user_id(comment_like['id'],self.id).first
        if (comment_likes_record.nil?)
          li  = LinkedinUserCommentLike.new(comment_like)
          linkedin_user_comment_likes << li
        else

          comment_likes_record.update_attributes(comment_like)
        end

      }
    else
      c comment_likes_record = LinkedinUserCommentLike.find_all_by_linkedin_id_and_linkedin_user_id(comment_likes['update']['id'],self.id).first
      if (comment_likes_record.nil?)
        li  = LinkedinUserCommentLike.new(comment_like)
        linkedin_user_comment_likes << li
      else

        comment_likes_record.update_attributes(comment_likes['update'])
      end

    end
  end

  def update_cmpy_from_people(cmpies)
    if cmpies.nil? || cmpies['update'].nil?
      return
    end

    cmpies_record = LinkedinUsercmpies.find_all_by_linkedin_user_id(self.id).first
    cmpies_record.update_attributes(cmpies)

  end

  def update_ncon_from_people(ncons)
    if ncons.nil? || ncons['update'].nil?
      return
    end

    ncons_record = LinkedinUserncons.find_all_by_linkedin_user_id(self.id).first
    ncons_record.update_attributes(ncons)

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
      ncons_hash = Hash.from_xml ncons
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

    people.add_certifications_from_people(certifications)
    people.add_skills_from_people(skills)
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
    people.add_ncon_from_people(ncons_hash)

  end

  def update_profile(peopleprofile,comment_like, cmpies, ncons)
    puts "update_profile"
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

    if !@hash['date_of_birth'].nil?
      @hash['date_of_birth'] = date_of_birth['year'] + '-' + date_of_birth['month'] + '-' + date_of_birth['day']
    end

    connections['total'] = @hash['num_connections']
    connections['connection'] = connections['person']

    update_attributes(@hash)

    # Update the associations

    update_certifications_from_people(certifications)
    update_connections_from_people(connections)
    update_positions_from_people(positions )
    update_current_shares_from_people(current_share)
    update_educations_from_people(educations)
    update_im_accounts_from_people(im_accounts)
    update_languages_from_people(languages)
    update_member_url_resources_from_people(member_url_resources)
    update_positions_from_people(three_past_positions)
    update_patents_from_people(patents)
    update_phone_numbers_from_people(phone_numbers)
    update_positions_from_people(positions)
    update_publications_from_people(publications)
    update_recommendations_receiveds_from_people(recommendations_receiveds)
    update_skills_from_people(skills)
    update_twitter_accounts_from_people(twitter_accounts)
    update_current_positions_from_people(three_current_positions)
    update_comment_likes_from_people(@comment_like_hash)
    update_cmpy_from_people(@cmpies_hash)
    update_ncon_from_people(@ncons_hash)
  end

end
