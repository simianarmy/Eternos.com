require File.expand_path("#{File.dirname(__FILE__)}/../../test_helper")

module Migrations
class SchemaStatementsByDefaultTest < Test::Unit::TestCase
  def test_should_not_have_plugin_schema_info_table
    assert !PluginSchemaInfo.table_exists?
  end
end

class SchemaStatementsTest < Test::Unit::TestCase
  def setup
    setup_schema_information
  end
  
  def test_should_create_plugin_schema_info_table
    assert PluginSchemaInfo.table_exists?
  end
  
  def teardown
    teardown_schema_information
  end
end

class SchemaStatementsWithExistingSchemaTest < Test::Unit::TestCase
  def setup
    setup_schema_information
  end
  
  def test_should_not_raise_an_exception
    assert_nothing_raised {setup_schema_information}
  end
  
  def teardown
    teardown_schema_information
  end
end
end
