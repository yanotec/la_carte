require 'test_helper'

class MenuTestRenderer < LaCarte::Renderer::Base; end

class LaCarte::Renderer::ClassMethodTest < LaCarte::TestCase
  def test_call_render_method_in_base_class_when_no_match_class_renderer
    params = lambda do |options|
      assert_equal({ builder: :nav }, options)

      'menu rendered'
    end

    LaCarte::Renderer::Base.stub :render, params do
      assert_equal 'menu rendered', LaCarte::Renderer.render(:menu, builder: :nav)
    end
  end

  def test_call_render_method_in_base_class_when_use_base_renderer_module
    params = lambda do |options|
      assert_equal({ builder: 'la_carte/', source: :nav }, options)

      'menu rendered'
    end

    LaCarte::Renderer::Base.stub :render, params do
      assert_equal 'menu rendered', LaCarte::Renderer.render('la_carte/', source: :nav)
    end
  end

  def test_call_render_method_in_renderer_class_based_name_params
    params = lambda do |options|
      assert_equal({ builder: :menu_test}, options)

      'menu rendered'
    end

    MenuTestRenderer.stub :render, params do
      assert_equal 'menu rendered', LaCarte::Renderer.render(:menu_test)
    end
  end

  def test_call_render_method_in_renderer_class_based_namei_and_type_params
    params = lambda do |options|
      assert_equal({ builder: :menu}, options)

      'menu rendered'
    end

    MenuTestRenderer.stub :render, params do
      assert_equal 'menu rendered', LaCarte::Renderer.render(:menu, type: :test)
    end
  end
end
