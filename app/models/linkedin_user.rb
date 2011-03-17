class LinkedinUser < ActiveRecord::Base
  belongs_to :linkedin_account
  has_many :linkedin_user_certifications
  has_many :linkedin_user_connections
  has_many :linkedin_user_educations
  has_many :linkedin_user_im_accounts
  has_many :linkedin_user_languages
  has_many :linkedin_user_patents
  has_many :linkedin_user_positions
  has_many :linkedin_user_past_positions
  has_many :linkedin_user_current_positions
  has_many :linkedin_user_publications
  has_many :linkedin_user_recommendations_receiveds
  has_many :linkedin_user_skills
  has_many :linkedin_user_twitter_accounts
  has_many :linkedin_user_member_url_resources
  has_many :linkedin_user_current_share
  has_many :linkedin_user_phone_numbers
  has_many :linkedin_user_comment_likes
  has_many :linkedin_user_cmpies
  has_many :linkedin_user_ncons

  def add_certifications_from_people(certifications)
    if certifications.nil?
      return
    end
    if Integer(certifications['total']) > 1

      certifications['certification'].each { |certification|
        li = linkedin_user_certifications.new(certification)
        linkedin_user_certifications << li
      }
    else
      li = linkedin_user_certifications.new(certifications['certification'])
      linkedin_user_certifications << li
    end
  end

  def add_skills_from_people(skills)
    if skills.nil?
      return
    end
    if Integer(skills['total']) > 1

      skills['skill'].each { |skill|
        li = linkedin_user_skills.new(skill)
        linkedin_user_skills << li
      }
    else
      li = linkedin_user_skills.new(skills['skill'])
      linkedin_user_skills << li
    end
  end

  def add_connections_from_people(connections)
    if connections.nil? || connections['connection'].nil?
      return
    end
    if Integer(connections['total']) > 1
      connections['connection'].each { |connection|
        li = linkedin_user_connections.new(connection)
        linkedin_user_connections << li
      }
    else
      li = linkedin_user_connections.new(connections['connection'])
      linkedin_user_connections << li
    end
  end

  def add_educations_from_people(educations)
    if educations.nil? || educations['education'].nil?
      return
    end
    if Integer(educations['total']) > 1
      educations['education'].each { |education|
        li = linkedin_user_educations.new(education)
        linkedin_user_educations << li
      }
    else
      li = linkedin_user_educations.new(educations['education'])
      linkedin_user_educations << li
    end
  end

  def add_im_account_from_people(im_accounts)
    if im_accounts.nil? || im_accounts['im_account'].nil?
      return
    end
    if Integer(im_accounts['total']) > 1
      im_accounts['im_account'].each { |im_account|
        li = linkedin_user_im_accounts.new(im_account)
        linkedin_user_im_accounts << li
      }
    else
      li = linkedin_user_im_accounts.new(im_accounts['im_account'])
      linkedin_user_im_accounts << li
    end
  end

  def add_languages_from_people(languages)
    if languages.nil? || languages['language'].nil?
      return
    end
    if Integer(languages['total']) > 1
      languages['language'].each { |language|
        li = linkedin_user_languages.new(language)
        linkedin_user_languages << li
      }
    else
      li = linkedin_user_languages.new(languages['language'])
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
        li = linkedin_user_patents.new(patent)
        linkedin_user_patents << li
        li.add_patent_inventors_from_people(inventors)
      }
    else
      inventors = patents['patent']['inventors']
      li = linkedin_user_patents.new(patents['patent'])
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
        li = linkedin_user_positions.new(position)
        linkedin_user_positions << li
      }
    else
      li = linkedin_user_positions.new(positions['position'])
      linkedin_user_positions << li
    end
  end
  def add_past_postions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = linkedin_user_past_positions.new(position)
        linkedin_user_past_positions << li
      }
    else
      li = linkedin_user_past_positions.new(positions['position'])
      linkedin_user_past_positions << li
    end
  end
  def add_current_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end
    if Integer(positions['total']) > 1
      positions['position'].each { |position|
        li = linkedin_user_current_positions.new(position)
        linkedin_user_current_positions << li
      }
    else
      li = linkedin_user_current_positions.new(positions['position'])
      linkedin_user_current_positions << li
    end
  end

  def add_publications_from_people(publications)
    if publications.nil? || publications['publication'].nil?
      return
    end

    if Integer(publications['total']) > 1
      publications['publication'].each { |publication|
        authors = publication['authors']
        li = linkedin_user_publications.new(publication)
        linkedin_user_publications << li
        li.add_publication_authors_from_people(authors)
      }
    else
      authors = publication['authors']
      li = linkedin_user_publications.new(publications['publication'])
      linkedin_user_publications << li
      li.add_publication_authors_from_people(authors)
    end
  end

  def add_recommendations_receiveds_from_people(recommendations)
    if recommendations.nil? || recommendations['recommendation'].nil?
      return
    end
    if Integer(recommendations['total']) > 1
      recommendations['recommendation'].each { |recommendations_received|
        li = linkedin_user_recommendations_receiveds.new(recommendations_received)
        linkedin_user_recommendations_receiveds << li
      }
    else
      li = linkedin_user_recommendations_receiveds.new(recommendations['recommendation'])
      linkedin_user_recommendations_receiveds << li
    end
  end
  def add_twitter_accounts_from_people(twitter_accounts)
    if twitter_accounts.nil? || twitter_accounts['twitter_account'].nil?
      return
    end
    if Integer(twitter_accounts['total']) > 1
      twitter_accounts['twitter_account'].each { |twitter_account|
        li = linkedin_user_twitter_accounts.new(twitter_account)
        linkedin_user_twitter_accounts << li
      }
    else
      li = linkedin_user_twitter_accounts.new(twitter_accounts['twitter_account'])
      linkedin_user_twitter_accounts << li
    end
  end

  def add_member_urls_from_people(member_urls)
    if member_urls.nil? || member_urls['member_url'].nil?
      return
    end
    if Integer(member_urls['total']) > 1
      member_urls['member_url'].each { |member_url|
        li = linkedin_user_member_url_resources.new(member_url)
        linkedin_user_member_url_resources << li
      }
    else
      li = linkedin_user_member_url_resources.new(member_urls['member_url'])
      linkedin_user_member_url_resources << li
    end
  end
  def add_curent_share_from_people(current_share)
    if current_share.nil?
      return
    end

    li = linkedin_user_current_share.new(current_share)
    linkedin_user_current_share << li

  end

  def add_phone_numbers_from_people(phone_numbers)
    if phone_numbers.nil? || phone_numbers['phone_number'].nil?
      return
    end
    if Integer(phone_numbers['total']) > 1
      phone_numbers['phone_number'].each { |phone_number|
        li = linkedin_user_phone_numbers.new(phone_number)
        linkedin_user_phone_numbers << li
      }
    else
      li = linkedin_user_phone_numbers.new(phone_numbers['phone_number'])
      linkedin_user_phone_numbers << li
    end
  end

  def add_comment_likes_from_people(comment_likes)
    if comment_likes.nil? || comment_likes['update'].nil?
      return
    end
    if Integer(comment_likes['total']) > 1
      comment_likes['update'].each { |comment_like|
        li = linkedin_user_comment_likes.new(comment_like)
        linkedin_user_comment_likes << li
      }
    else
      li = linkedin_user_comment_likes.new(comment_likes['update'])
      linkedin_user_comment_likes << li
    end
  end

  def add_cmpy_from_people(cmpies)
    if cmpies.nil? || cmpies['update'].nil?
      return
    end
    if Integer(cmpies['total'])>1
      cmpies ['update'].each { |update|

        li = linkedin_user_cmpies.new(update)
        linkedin_user_cmpies << li
      }
    else
      li = linkedin_user_cmpies.new(cmpies['update'])
      linkedin_user_cmpies << li
    end
  end

  def add_ncon_from_people(ncons)
    if ncons.nil? || ncons['updates'].nil?
      return
    end
    li = linkedin_user_ncons.new(ncons['update'])
    linkedin_user_ncons << li
  end

  def update_certifications_from_people(certifications)
    if certifications.nil?
      return
    end

    array =[]
    if Integer(certifications['total']) > 1
      certifications['certification'].each { |certification|
        array.push certification['id']
        certifications_record = linkedin_user_certifications.find_by_certification_id(certification['id'])
        if (certifications_record.nil?)
          li = linkedin_user_certifications.new(certification)
          linkedin_user_certifications << li
        else
          certifications_record.update_attributes(certification)
        end

      }
    else
      certification = certifications['certification']
      array.push certification['id']
      certifications_record = linkedin_user_certifications.find_by_certification_id(certification['id'])
      if (certifications_record.nil?)

        li = linkedin_user_certifications.new(certification)

        linkedin_user_certifications << li
      else
        certifications_record.update_attributes(certification)
      end
    end
    linkedin_user_certifications.find(:all, :conditions=> ["certification_id not in (?)" , array]).each{ |record|
      record.destroy
    }	                                 
  end

  def update_skills_from_people(skills)
    if skills.nil?
      return
    end

    array =[]

    if Integer(skills['total']) > 1

      skills['skill'].each { |skill|
        array.push skill['id']
        skills_record = linkedin_user_skills.find_by_skill_id(skill['id'])
        if (skills_record.nil?)
          li = linkedin_user_skills.new(skill)
          linkedin_user_skills << li
        else
          skills_record.update_attributes(skill)
        end

      }
    else
      skill = skills['skill']
      array.push skill['id']
      skills_record = linkedin_user_skills.find_by_skill_id(skill['id'])
      if (skills_record.nil?)

        li = linkedin_user_skills.new(skill)
        linkedin_user_skills << li
      else
        skills_record.update_attributes(skills['skill'])
      end

    end
    linkedin_user_skills.find(:all, :conditions=> ["skill_id not in (?)" , array]).each{ |record|
      record.destroy
    }	                                 
  end

  def update_connections_from_people(connections)
    if connections.nil? || connections['connection'].nil?
      return
    end

    array =[]

    if Integer(connections['total']) > 1

      connections['connection'].each { |connection|
        array.push connection['id']
        connections_record = LinkedinUserConnection.find_by_linkedin_id(connection['id'])
        if (connections_record.nil?)
          li = LinkedinUserConnection.new(connection)
          linkedin_user_connections << li
        else
          connections_record.update_attributes(connection)
        end


      }
    else
      connection  = connections['connection']
      connections_record = linkedin_user_connections.find_by_linkedin_id(connections['connection']['id'])
      array.push connection['id']
      if (connections_record.nil?)
        li = linkedin_user_connections.new(connection)
        linkedin_user_connections << li
      else
        connections_record.update_attributes(connections['connection'])
      end
    end
    linkedin_user_connections.find(:all, :conditions=> ["linkedin_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end

  def update_educations_from_people(educations)
    if educations.nil? || educations['education'].nil?
      return
    end

    array =[]

    if Integer(educations['total']) > 1

      educations['education'].each { |education|
        array.push education['id']
        educations_record = LinkedinUserEducation.find_by_education_id(education['id'])
        if (educations_record.nil?)
          li = LinkedinUserEducation.new(education)
          linkedin_user_educations << li
        else
          educations_record.update_attributes(education)
        end

      }
    else
      education = educations['education']
      array.push education['id']
      educations_record = linkedin_user_educations.find_by_education_id(educations['education']['id'])
      if (educations_record.nil?)
        li = linkedin_user_educations.new(educations['education'])
        linkedin_user_educations << li
      else
        educations_record.update_attributes(educations['education'])
      end

    end
    linkedin_user_educations.find(:all, :conditions=> ["education_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end

  def update_im_accounts_from_people(im_accounts)
    if im_accounts.nil? || im_accounts['im_account'].nil?
      return
    end

    linkedin_user_im_accounts.delete
    add_im_account_from_people(im_accounts)    
  end

  def update_languages_from_people(languages)
    if languages.nil? || languages['language'].nil?
      return
    end

    array =[]

    if Integer(languages['total']) > 1

      languages['language'].each { |language|
        array.push languages['id']
        languages_record = linkedin_user_languages.find_by_language_id(language['id'])
        if (languages_record.nil?)
          li = linkedin_user_languages.new(language)
          linkedin_user_languages << li
        else
          languages_record.update_attributes(language)
        end

      }
    else

      language = languages['language']
      array.push languages['id']
      languages_record = linkedin_user_languages.find_by_language_id(languages['language']['id'])
      if (languages_record.nil?)
        li = linkedin_user_languages.new(language)
        linkedin_user_languages << li
      else
        languages_record.update_attributes(languages['language'])
      end

    end
    linkedin_user_languages.find(:all, :conditions=> ["language_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end

  def update_patents_from_people(patents)
    if patents.nil? || patents['patent'].nil?
      return
    end

    array =[]

    if Integer(patents['total']) > 1

      patents['patent'].each { |patent|
        array.push patent['id']
        patents_record = linkedin_user_patents.find_by_patent_id(patent['id'])
        if (patents_record.nil?)
          li = linkedin_user_patents.new(patent)
          linkedin_user_patents << li
        else
          patents_record.update_attributes(patent)
        end

      }
    else
      patent = patents['patent']
      array.push patents['patent']['id']
      patents_record = linkedin_user_patents.find_by_patent_id(patents['patent']['id'])
      if (patents_record.nil?)
        li = linkedin_user_patents.new(patent)
        linkedin_user_patents << li
      else
        patents_record.update_attributes(patents['patent'])
      end

    end
    linkedin_user_patents.find(:all, :conditions=> ["patent_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end

  def update_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end

    array =[]
    if Integer(positions['total']) > 1

      positions['position'].each { |position|
        array.push position['id']
        positions_record = LinkedinUserPosition.find_by_position_id(position['id'])

        if (positions_record.nil?)
          li = LinkedinUserPosition.new(position)

          linkedin_user_positions << li
        else

          positions_record.update_attributes(position)
        end

      }
    else
      array.push positions['position']['id']
      position = positions['position']
      positions_record = LinkedinUserPosition.find_by_position_id(positions['position']['id'])
      if (positions_record.nil?)
        li = LinkedinUserPosition.new(position)
        linkedin_user_positions << li
      else

        positions_record.update_attributes(positions['position'])
      end

    end
    linkedin_user_positions.find(:all, :conditions=> ["position_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end

  def update_past_postions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end

    linkedin_user_past_positions.delete
    add_past_positions_from_people(positions)
  end

  def update_current_positions_from_people(positions)
    if positions.nil? || positions['position'].nil?
      return
    end

    linkedin_user_current_positions.delete
    add_current_positions_from_people(positions)
  end

  def update_publications_from_people(publications)
    if publications.nil? || publications['publication'].nil?
      return
    end

    array =[]
    if Integer(publications['total']) > 1

      publications['publication'].each { |publication|
        array.push publication['id']
        publications_record = linkedin_user_publications.find_by_publication_id(publication['id'])
        if (publications_record.nil?)
          li = linkedin_user_publications.new(publication)
          linkedin_user_publications << li
        else
          publications_record = linkedin_user_publications.find_by_linkedin_user_id(self.id)
          publications_record.update_attributes(publication)
        end
      }
    else
      array.push publications['publication']['id']
      publication = publications['publication']
      publications_record = linkedin_user_publications.find_by_publication_id(publications['publication']['id'])
      if (publications_record.nil?)
        li = linkedin_user_publications.new(publication)
        linkedin_user_publications << li
      else
        publications_record.update_attributes(publications['publication'])
      end
    end
    linkedin_user_publications.find(:all, :conditions=> ["publication_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end


  def update_recommendations_receiveds_from_people(recommendations)
    if recommendations.nil? || recommendations['recommendation'].nil?
      return
    end
    array =[]
    if Integer(recommendations['total']) > 1

      recommendations['recommendations'].each { |recommendation|
        array.push recommendation['id']
        recommendations_receiveds_record = linkedin_user_recommendations_receiveds.find_by_recommendation_id(recommendation['id'])
        if (recommendations_receiveds_record.nil?)
          li = linkedin_user_recommendations_receiveds.new(recommendation)
          linkedin_user_recommendations_receiveds << li
        else

          recommendations_receiveds_record.update_attributes(recommendation)
        end

      }
    else
      array.push recommendations['recommendation']['id']
      recommendations_receiveds_record = linkedin_user_recommendations_receiveds.find_by_recommendation_id(recommendations['recommendation']['id'])
      if (recommendations_receiveds_record.nil?)
        li = linkedin_user_recommendations_receiveds.new(recommendations['recommendation'])
        linkedin_user_recommendations_receiveds << li
      else
        recommendations_receiveds_record.update_attributes(recommendations['recommendation'])
      end

    end
    linkedin_user_recommendations_receiveds.find(:all, :conditions=> ["linkedin_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end
  def update_twitter_accounts_from_people(twitter_accounts)
    if twitter_accounts.nil? || twitter_accounts['twitter_account'].nil?
      return
    end
    linkedin_user_twitter_accounts.delete
    add_twitter_accounts_from_people(twitter_accounts)
  end


  def update_member_url_resources_from_people(member_urls)
    if member_urls.nil? || member_urls['member_url'].nil?
      return
    end

    linkedin_user_member_url_resources.delete
    add_member_urls_from_people(member_urls)
  end

  def update_current_shares_from_people(current_share)
    if current_share.nil?
      return
    end

    current_shares_record = linkedin_user_current_share.find_by_linkedin_user_id(self.id)
    current_shares_record.update_attributes(current_share)


  end

  def update_phone_numbers_from_people(phone_numbers)
    if phone_numbers.nil? || phone_numbers['phone_number'].nil?
      return
    end
    linkedin_user_phone_numbers.delete
    add_phone_numbers_from_people(phone_numbers)
  end

  def update_comment_likes_from_people(comment_likes)
    if comment_likes.nil? || comment_likes['update'].nil?
      return
    end

    array =[]
    if Integer(comment_likes['total']) > 1

      comment_likes['update'].each { |comment_like|
        array.push comment_like['id']
        comment_likes_record = linkedin_user_comment_likes.find_by_linkedin_id(comment_like['id'])
        if (comment_likes_record.nil?)
          li = linkedin_user_comment_likes.new(comment_like)
          linkedin_user_comment_likes << li
        else

          comment_likes_record.update_attributes(comment_like)
        end

      }
    else
      array.push comment_likes['update']['id']
      comment_like = comment_likes['update']
      comment_likes_record = linkedin_user_comment_likes.find_by_linkedin_id(comment_likes['update']['id'])
      if (comment_likes_record.nil?)
        li = linkedin_user_comment_likes.new(comment_like)
        linkedin_user_comment_likes << li
      else

        comment_likes_record.update_attributes(comment_likes['update'])
      end

    end

    linkedin_user_comment_likes.find(:all, :conditions=> ["linkedin_id not in (?)" , array]).each{ |record|
      record.destroy
    }
  end

  def update_cmpy_from_people(cmpies)
    if cmpies.nil? || cmpies['update'].nil?
      return
    end

    cmpies_record = linkedin_user_cmpies.find_by_linkedin_user_id(self.id)
    cmpies_record.update_attributes(cmpies['update'])

  end

  def update_ncon_from_people(ncons)
    if ncons.nil? || ncons['update'].nil?
      return
    end

    ncons_record = linkedin_user_ncons.find_by_linkedin_user_id(self.id)
    ncons_record.update_attributes(ncons['update'])
  end
  
  def process_hash (hash)
    if !hash['id'].nil?
      hash['linkedin_id'] = hash.delete('id')
    end
    result = Hash.new
    if !hash['im_accounts'].nil?
      result['im_accounts'] = hash.delete('im_accounts')
    end

    if !hash['location'].nil?
      result['location'] = hash.delete('location')
    end
    if !hash['positions'].nil?
      result['positions'] = hash.delete('positions')
    end
    if !hash['educations'].nil?
      result['educations'] = hash.delete('educations')
    end
    if !hash['three_current_positions'].nil?
      result['three_current_positions'] = hash.delete('three_current_positions')
    end
    if !hash['three_past_positions'].nil?
      result['three_past_positions'] = hash.delete('three_past_positions')
    end
    if !hash['recommendations_received'].nil?
      result['recommendations_receiveds'] = hash.delete('recommendations_received')
    end

    if !hash['member_url_resources'].nil?
      result['member_url_resources'] = hash.delete('member_url_resources')
    end
    if !hash['relation_to_viewer'].nil?
      hash.delete('relation_to_viewer')
    end
    if !hash['date_of_birth'].nil?
      result['date_of_birth'] = hash.delete('date_of_birth')
    end
    if !hash['connections'].nil?
      result['connections'] = hash.delete('connections')
    end
    if !hash['current_share'].nil?
      result['current_share'] = hash.delete('current_share')
    end
    if !hash['phone_numbers'].nil?
      result['phone_numbers'] = hash.delete('phone_numbers')
    end
    if !hash['twitter_accounts'].nil?
      result['twitter_accounts'] = hash.delete('twitter_accounts')
    end
    if !hash['skills'].nil?
      result['skills'] = hash.delete('skills')
    end

    if !hash['patents'].nil?
      result['patents'] = hash.delete('patents')
    end

    if !hash['certifications'].nil?
      result['certifications'] = hash.delete('certifications')
    end

    if !hash['languages'].nil?
      result['languages'] = hash.delete('languages')
    end

    if !hash['publications'].nil?
      result['publications'] = hash.delete('publications')
    end
    hash['current_status_timestamp'] = Time.at(Integer(hash['current_status_timestamp']) / 1000)
    hash['location_code'] = result['location']['country']['code']
    
    if !hash['date_of_birth'].nil?
      hash['date_of_birth'] = date_of_birth['year'] + '-' + date_of_birth['month'] + '-' + date_of_birth['day']
    end

    result['connections']['total'] = hash['num_connections']
    result['connections']['connection'] = result['connections']['person']
    result
  end

  def init(peopleprofile, comment_like, cmpies, ncons)
    @hash = (Hash.from_xml peopleprofile)['person']
    
    # Ensure *some* data
    unless @hash = (Hash.from_xml peopleprofile)['person']
      Rails.logger.warn "Nil value returned from linkedin profile!"
      return false
    end
    # Ensure linkedin is present
    unless @hash['id']
      Rails.logger.warn "No linkedin ID returned in info!"
      return false
    end
    @hash['linkedin_id'] = @hash.delete('id')
    
    if !comment_like.nil?
      @comment_like_hash = (Hash.from_xml comment_like)['updates']
    end

    if !cmpies.nil?
      @cmpies_hash = (Hash.from_xml cmpies)['updates']
    end

    if !ncons.nil?
      ncons_hash = Hash.from_xml ncons
    end
    
    temp = process_hash @hash
    update_attributes! @hash
    
    add_certifications_from_people(temp['certifications'])
    add_skills_from_people(temp['skills'])
    add_connections_from_people(temp['connections'])
    add_past_postions_from_people(temp['three_past_positions'])
    add_current_positions_from_people(temp['three_current_positions'])
    add_educations_from_people(temp['educations'])
    add_im_account_from_people(temp['im_accounts'])
    add_languages_from_people(temp['anguages'])
    add_patents_from_people(temp['patents'])
    add_positions_from_people(temp['positions'])
    add_publications_from_people(temp['publications'])
    add_recommendations_receiveds_from_people(temp['recommendations_receiveds'])
    add_twitter_accounts_from_people(temp['twitter_accounts'])
    add_member_urls_from_people(temp['member_url_resources'])
    add_curent_share_from_people(temp['current_share'])
    add_phone_numbers_from_people(temp['phone_numbers'])
    add_comment_likes_from_people(@comment_like_hash)
    add_cmpy_from_people(@cmpies_hash)
    add_ncon_from_people(ncons_hash)
  end

  def sync(peopleprofile, comment_like, cmpies, ncons)
    if !comment_like.nil?
      update_comment_likes_from_people (Hash.from_xml comment_like)['updates']
    end

    if !cmpies.nil?
      update_cmpy_from_people (Hash.from_xml cmpies)['updates']
    end

    if !ncons.nil?
      update_ncon_from_people Hash.from_xml ncons
    end

    unless @hash = (Hash.from_xml peopleprofile)['person']
      Rails.logger.warn "Nil value returned from linkedin profile!"
      return false
    end

    temp = process_hash(@hash)
    update_attributes(@hash) 

    # Update the associations
    update_certifications_from_people(temp['certifications'])
    update_connections_from_people(temp['connections'])
    update_positions_from_people(temp['positions'])
    update_current_shares_from_people(temp['current_share'])
    update_educations_from_people(temp['educations'])
    update_im_accounts_from_people(temp['im_accounts'])
    update_languages_from_people(temp['languages'])
    update_member_url_resources_from_people(temp['member_url_resources'])
    update_positions_from_people(temp['three_past_positions'])
    update_patents_from_people(temp['patents'])
    update_phone_numbers_from_people(temp['phone_numbers'])
    update_positions_from_people(temp['positions'])
    update_publications_from_people(temp['publications'])
    update_recommendations_receiveds_from_people(temp['recommendations_receiveds'])
    update_skills_from_people(temp['skills'])
    update_twitter_accounts_from_people(temp['twitter_accounts'])
    update_current_positions_from_people(temp['three_current_positions'])
  end

end


