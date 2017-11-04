require "test_helper"

class LaCarteTest < LaCarte::TestCase
  def test_configure_block_required
    assert_raises LocalJumpError do
      LaCarte.configure
    end
  end

  def test_configure_block_yields_configuration_class_instance
    LaCarte.configure do |config|
      assert_instance_of LaCarte::Configuration, config
    end
  end

  def test_config_to_call_instance_in_configuration_class
    instance = Minitest::Mock.new
    instance.expect :call, instance, []

    LaCarte::Configuration.stub :instance, instance do
      LaCarte.config
    end

    assert instance.verify
  end
end
