require 'test_helper'

class MenuTestRenderer < LaCarte::Renderer::Base; end
class SubMenuTestRenderer < MenuTestRenderer; end

class LaCarte::Renderer::Base::InheritanceTest < LaCarte::TestCase
  def test_exception_raised_when_call_base_class_to_class_renderer_base
    assert_raises LaCarte::RendererError do
      LaCarte::Renderer::Base.base_class
    end
  end

  def test_base_class_activerecord_error
    klass = Class.new { include LaCarte::Renderer::Inheritance }
    assert_raises LaCarte::RendererError do
      klass.base_class
    end
  end

  def test_base_class_returns_class_when_called_on_class_base
    assert_equal MenuTestRenderer, MenuTestRenderer.base_class
  end

  def test_base_class_return_class_when_called_on_subclass
    assert_equal MenuTestRenderer, SubMenuTestRenderer.base_class
  end

  def test_class_name_returning_the_demodularized_name_without_suffix
    assert_equal 'base_class', LaCarte::Renderer::Base.class_name
    assert_equal 'menu_test', MenuTestRenderer.class_name
    assert_equal 'sub_menu_test', SubMenuTestRenderer.class_name
  end
end
