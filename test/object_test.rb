require File.expand_path "../test_helper", __FILE__
require 'base64'

context "Rugged::Object stuff" do
  setup do
    @path = File.dirname(__FILE__) + '/fixtures/testrepo.git/'
    @repo = Rugged::Repository.new(@path)
  end

  test "cannot lookup a non-existant object" do
    assert_raise RuntimeError do 
      obj = @repo.lookup("a496071c1b46c854b31185ea97743be6a8774479")
    end
  end

  test "can lookup an object" do
    obj = @repo.lookup("8496071c1b46c854b31185ea97743be6a8774479")
    assert_equal 'commit', obj.type
    assert_equal '8496071c1b46c854b31185ea97743be6a8774479', obj.oid

    if defined? Encoding
      with_default_encoding('utf-8') do |enc|
        obj = @repo.lookup("8496071c1b46c854b31185ea97743be6a8774479")
        assert_equal enc, obj.type.encoding
        assert_equal enc, obj.oid.encoding
      end

      with_default_encoding('ascii') do |enc|
        obj = @repo.lookup("8496071c1b46c854b31185ea97743be6a8774479")
        assert_equal enc, obj.type.encoding
        assert_equal enc, obj.oid.encoding
      end
    end
  end

  test "same looked up objects are the same" do
    obj = @repo.lookup("8496071c1b46c854b31185ea97743be6a8774479")
    obj2 = @repo.lookup("8496071c1b46c854b31185ea97743be6a8774479")
    assert_equal obj, obj2
  end
  
  test "can read raw data from an object" do
    obj = @repo.lookup("8496071c1b46c854b31185ea97743be6a8774479")
    assert obj.read_raw
  end

end
