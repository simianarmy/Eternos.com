# $Id$
# This is an add-on to the ActiveRecord::Base class.  It allows simple searching to be
# accomplished by using, for example, @movies = Movie.search("text")
module Searchable
  # Allow the user to set the default searchable fields
  def searches_on(*args)
    if not args.empty? and args.first != :all
      @searchable_fields = args.collect { |f| f.to_s }
    end
  end
  
  # Return the default set of fields to search on
  def searchable_fields(tables = nil, klass = self)
    # If the model has declared what it searches_on, then use that...
    return @searchable_fields unless @searchable_fields.nil?
    
    # ... otherwise, use all text/varchar fields as the default
    fields = []
    tables ||= []
    string_columns = klass.columns.select { |c| c.type == :text or c.type == :string }
    fields = string_columns.collect { |c| klass.table_name + "." + c.name }
    
    if not tables.empty?
      tables.each do |table|
        klass = eval table.to_s.classify
        fields += searchable_fields([], klass)
      end
    end
    
    return fields
  end
  
  # Search the stories database for the given parameters:
  #   text = a string to search for
  #   options take standard find options, as well as:
  #
  #   :only => an array of fields in which to search for the text;
  #     default is 'all text or string columns'
  #   :except => an array of fields to exclude from the default searchable columns
  #   :case => :sensitive or :insensitive
  
  def search(text = nil, options={})
    with_scope :find => {:conditions => search_conditions(text, options)} do
      find :all, options
    end
  end
  
  def search_conditions(query, options={})
    return nil if query.blank?
    
    # The fields to search (default is all text fields)
    fields = options[:only] || searchable_fields(options[:include])
    fields -= options[:except] if not options[:except].nil?
    case_sensitive = (options[:case] == :sensitive)
    
    # Split the query by commas as well as spaces
    words = query.split(",").map(&:split).flatten
    
    # From Rails Recipes #24
    binds = {}
    or_frags = []
    count = 1
    
    # Now build the SQL for the search if there is text to search for
    words.each do |word|
      like_frags = [fields].flatten.map { |f| field_case(f, case_sensitive) + " LIKE :word#{count}" }
      or_frags << "(#{like_frags.join(" OR ")})"
      binds["word#{count}".to_sym] = "%#{case_sensitive ? word.to_s : word.to_s.downcase}%"
    end
    
    [or_frags.join(" AND "), binds]
  end
  
  def field_case(field, case_sensitive)
    case_sensitive ? field : "LOWER(#{field})"
  end
end
