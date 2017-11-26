require 'test_helper'

class MenuTestRenderer < LaCarte::Renderer::Base; end
class SubMenuTestRenderer < MenuTestRenderer; end

class LaCarte::Renderer::Base::ClassMethodTest < LaCarte::TestCase
  def test_call_new_method_in_base_class_when_no_match_class_renderer
    instance = Minitest::Mock.new
    instance.expect :render, 'menu rendered'

    params = lambda do |options|
      assert_equal({ source: :nav }, options)

      instance
    end

    LaCarte::Renderer::Base.stub :new, params do
      assert_equal 'menu rendered', LaCarte::Renderer::Base.render(source: :nav)
    end

    assert instance.verify
  end
end
