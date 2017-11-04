require "test_helper"

class LaCarte::Configuration::ClassMethodTest < LaCarte::TestCase
  def test_check_new_method_private
    assert_private_method LaCarte::Configuration, :new
  end

  def test_configure_require_block_yields
    assert_raises LocalJumpError do
      LaCarte::Configuration.configure
    end
  end

  def test_configure_to_call_instance_method
    instance = Minitest::Mock.new
    instance.expect :call, instance, []

    LaCarte::Configuration.stub :instance, instance do
      LaCarte.configure {|_| }
    end

    assert instance.verify
  end

  def test_instance_returns_configuration_class_instance
    assert_instance_of LaCarte::Configuration, LaCarte::Configuration.instance
  end

  def test_instance_singleton
    instance = LaCarte::Configuration.instance
    assert_equal instance, LaCarte::Configuration.instance

    Thread.current[:la_carte_config] = nil # clear singleton instance
    refute_equal instance, LaCarte::Configuration.instance
    refute_nil instance
  end
end
