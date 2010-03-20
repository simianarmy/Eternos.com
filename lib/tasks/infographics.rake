# $Id$
#
# Rake tasks for performing text processing & analysis on member data
# To be used for Tag clouds & other member infographics

namespace :infographics do
  desc "Creates new text dump for all users"
  task :update_fulltext => :environment do
    # Use thinking_sphinx riddle config-building snippet to generate text queries
    sql_queries = []
    ThinkingSphinx.context.indexed_models.each do |model|
      model = model.constantize
      model.define_indexes
      model.sphinx_indexes.each do |idx|
        idx.sources.each do |src|
          sql_queries << src.to_sql
        end
      end
    end
    
    # Per-user task
    User.active.find_each do |u|
      if raw = RawText.find_by_user_id(u.id)
        latest = raw.updated_at
      else
        latest = u.created_at
      end
      puts "Updating text dump for user #{u.id} since #{latest}..."
      
      # Begin collecting & adding text to raw_text table
      # Scope query to user
      sql_queries.each do |sql|
        sql.gsub!('$start', u.id.to_s)
        sql.gsub!('$end', u.id.to_s)
        puts "SQL => #{sql}\n\n"
        res = ActiveRecord::Base.connection.execute(sql)
      end
      break
    end
  end
end
  