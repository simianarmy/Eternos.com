# $Id$
class CreateCountriesFromModel < ActiveRecord::Migration
  class TmpCountry < ActiveRecord::Base
  end
  def self.up
    say "Creating temp countries table"
    create_table :tmp_countries, :id => false do |t|
      t.integer :id, :null => false, :default => 0
      t.string :name, :official_name, :alpha_2_code, :alpha_3_code
    end
    say "Populating countries"
    CountryEnumerated.find(:all).each do |c|
      execute "INSERT INTO countries VALUES (#{c.id}, '#{c.name.gsub(/\\/, '\&\&').gsub(/'/, "''")}', " +
        "'#{c.official_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}', '#{c.abbreviation_2}', '#{c.abbreviation_3}')"
    end
    say "Renaming temp countries to countries"
    rename_table :tmp_countries, :countries
  end

  def self.down
    drop_table :countries
  end
end
