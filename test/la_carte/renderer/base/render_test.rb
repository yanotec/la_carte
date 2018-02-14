require 'test_helper'

class LaCarte::Renderer::Base::Render < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_render_a_simple_menu
    config.add_source_path :menu, sources_dir.join('one_level.yml')

    assert_equal(
      "<div class=\"menu\"><ul><li>Home</li></ul></div>",
      instance(builder: :menu).render
    )
  end

  private

  def instance(*args)
    @instance ||= LaCarte::Renderer::Base.new(*args)
  end
end
