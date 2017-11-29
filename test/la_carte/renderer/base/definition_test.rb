require 'test_helper'

class MenuTestRenderer < LaCarte::Renderer::Base; end

class LaCarte::Renderer::Base::DefinitionTest < LaCarte::TestCase
  def test_define_pattern_build_a_renderer_pattern
    instance = Minitest::Mock.new
    instance.expect :build, instance

    LaCarte::Renderer::Base.stub :pattern, instance do
      LaCarte::Renderer::Base.define_pattern {}
    end

    assert instance.verify
  end

  def test_pattern_returns_a_la_carte_renderer_pattern_instance
    LaCarte::Renderer::Pattern.stub :new, 'instance' do
      assert_equal 'instance', LaCarte::Renderer::Base.pattern
    end
  end

  def test_the_immutability_of_pattern_within_the_class
    LaCarte::Renderer::Pattern.stub :new, 'instance' do
      assert_equal 'instance', LaCarte::Renderer::Base.pattern
    end
    LaCarte::Renderer::Pattern.stub :new, 'other instance' do
      assert_equal 'instance', LaCarte::Renderer::Base.pattern
    end
  end

  def test_the_mutability_of_pattern_between_different_classes
    LaCarte::Renderer::Pattern.stub :new, 'instance' do
      assert_equal 'instance', LaCarte::Renderer::Base.pattern
    end
    LaCarte::Renderer::Pattern.stub :new, 'other instance' do
      assert_equal 'other instance', MenuTestRenderer.pattern
    end
  end
end
