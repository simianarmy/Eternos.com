require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'person')

class LuciferTest < Test::Unit::TestCase

  def test_encrypt_proper_columns
    assert_equal ['ssn_b'], Person.encrypted_columns
  end
  
  def test_track_decrypted_columns
    assert_equal ['ssn'], Person.decrypted_columns
  end
  
  def test_setup_virtual_attributes
    assert Person.new.respond_to?(:ssn)
    assert Person.new.respond_to?('ssn=')
  end
  
  def test_encrypt_column_before_save
    person = Person.new :name=>'Alice', :ssn=>'000-00-0000'
    assert_nil person.ssn_b
    person.save
    assert person.ssn_b
    assert_not_equal '000-00-0000', person.ssn_b
  end
  
  def test_decrypt_column_on_attribute_access
    id = Person.create(:name=>'Bob', :ssn=>'999-99-9999').id
    person = Person.find id
    assert_equal '999-99-9999', person.ssn
  end
end