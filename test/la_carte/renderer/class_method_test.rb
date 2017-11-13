require 'test_helper'

class MenuTestRenderer < LaCarte::Renderer::Base; end

class LaCarte::Renderer::ClassMethodTest < LaCarte::TestCase
  def test_call_render_method_in_base_class_when_no_match_class_renderer
    params = lambda do |name, options|
      assert_equal :menu, name
      assert_equal({ source: :nav }, options)

      'menu rendered'
    end

    LaCarte::Renderer::Base.stub :render, params do
      assert_equal 'menu rendered', LaCarte::Renderer.render(:menu, source: :nav)
    end
  end

  def test_call_render_method_in_base_class_when_use_base_renderer_module
    params = lambda do |name, options|
      assert_equal 'la_carte/', name
      assert_equal({}, options)

      'menu rendered'
    end

    LaCarte::Renderer::Base.stub :render, params do
      assert_equal 'menu rendered', LaCarte::Renderer.render('la_carte/')
    end
  end

  def test_call_render_method_in_renderer_class_based_name_params
    params = lambda do |name, options|
      assert_equal :menu_test, name
      assert_equal({}, options)

      'menu rendered'
    end

    MenuTestRenderer.stub :render, params do
      assert_equal 'menu rendered', LaCarte::Renderer.render(:menu_test)
    end
  end
end
