require "test_helper"

class LaCarteTest < LaCarte::TestCase
  def test_configure_block_required
    assert_raises ArgumentError do
      LaCarte.configure
    end
  end

  def test_configure_block_yields_configuration_class_instance
    context = self
    LaCarte.configure do
      context.assert_instance_of LaCarte::Configuration, config
    end
  end

  def test_config_to_call_instance_in_configuration_class
    LaCarte::Configuration.stub :instance, "instance" do
      assert_equal "instance", LaCarte.config
    end
  end

  def test_render_to_call_renderer_render_method
    params = lambda do |name, options|
      # We're making sure that the correct arguments are passed along
      assert_equal 'menu', name
      assert_equal({ params: 'params' }, options)
    end

    LaCarte::Renderer.stub :render, params do
      LaCarte.render 'menu', params: 'params'
    end
  end
end
