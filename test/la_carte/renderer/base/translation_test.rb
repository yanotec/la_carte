require 'test_helper'

class MenuTestRenderer < LaCarte::Renderer::Base; end
class SubMenuTestRenderer < MenuTestRenderer; end

class LaCarte::Renderer::Base::TranslationTest < LaCarte::TestCase
  def setup
    super
    I18n.backend = I18n::Backend::Simple.new
    I18n.backend.store_translations "en", hi: "Hi!"
  end

  def teardown
    super
    I18n.backend.reload!
  end

  def test_lookup_ancestors_to_class_base
    assert_equal [LaCarte::Renderer::Base], LaCarte::Renderer::Base.lookup_ancestors
  end

  def test_lookup_ancestors_to_subclass
    assert_equal [MenuTestRenderer], MenuTestRenderer.lookup_ancestors
  end

  def test_lookup_ancestors_to_subclass_of_subclass
    assert_equal [SubMenuTestRenderer, MenuTestRenderer], SubMenuTestRenderer.lookup_ancestors
  end

  def test_i18n_key
    assert_equal :base, LaCarte::Renderer::Base.i18n_key
    assert_equal :menu_test, MenuTestRenderer.i18n_key
    assert_equal :sub_menu_test, SubMenuTestRenderer.i18n_key
  end

  def test_translated_renderer_text
    I18n.backend.store_translations "en", la_carte: { renderer: { menu_test: { home: "Home Menu" } } }
    assert_equal "Home Menu", MenuTestRenderer.human("home")
  end

  def test_translated_renderer_text_with_default
    I18n.backend.store_translations "en", la_carte: { renderer: { home: "Home Default" } }
    assert_equal "Home Default", MenuTestRenderer.human("home")
  end

  def test_translated_renderer_text_using_default_option
    assert_equal "Default", MenuTestRenderer.human("home", default: 'Default')
  end

  def test_translated_renderer_text_falling_back_to_default
    assert_equal "Home", MenuTestRenderer.human("home")
  end

  def test_translated_renderer_text_with_symbols
    I18n.backend.store_translations "en", la_carte: { renderer: { menu_test: { home: "Home Menu" } } }
    assert_equal "Home Menu", MenuTestRenderer.human(:home)
  end

  def test_translated_renderer_text_with_ancestor
    I18n.backend.store_translations "en", la_carte: { renderer: { sub_menu_test: { home: "Home Sub Menu" } } }
    assert_equal "Home Sub Menu", SubMenuTestRenderer.human(:home)
  end

  def test_translated_renderer_text_with_ancestors_fallback
    I18n.backend.store_translations "en", la_carte: { renderer: { menu_test: { home: "Home Menu" } } }
    assert_equal "Home Menu", SubMenuTestRenderer.human(:home)
  end

  def test_translated_deeply_nested_renderer_text
    I18n.backend.store_translations "en", la_carte: { renderer: { menu_test: { home: "Home Menu" } } }
    assert_equal "Home Menu", MenuTestRenderer.human('home.dashboard')
  end

  def test_human_does_not_modify_options
    options = { default: "immutable" }
    MenuTestRenderer.human('home', options)
    assert_equal({ default: "immutable" }, options)
  end
end
