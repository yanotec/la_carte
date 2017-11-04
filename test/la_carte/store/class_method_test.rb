require "test_helper"

class LaCarte::Store::ClassMethodTest < LaCarte::TestCase
  def test_check_new_method_private
    assert_private_method LaCarte::Store, :new
  end

  def test_store_returns_configuration_class_instance
    assert_instance_of LaCarte::Store, LaCarte::Store.store
  end

  def test_instance_singleton
    instance = LaCarte::Store.store
    assert_equal instance, LaCarte::Store.store

    Thread.current[:la_carte_store] = nil # clear singleton instance
    refute_equal instance, LaCarte::Store.store
    refute_nil instance
  end
end
