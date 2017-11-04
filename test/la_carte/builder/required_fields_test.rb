require 'test_helper'

class LaCarte::Builder::LoadStoreTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_check_fields_when_require_fields
    config.add_source_path :menu, sources_dir.join('one_level.yml')
    config.add_required_fields :name, :url, to: :menu

    assert_equal [{name: 'home', url: '/'}], instance.build(:menu)
  end

  def test_check_fields_when_require_url_on_tow_levels
    config.add_source_path :menu, sources_dir.join('two_levels.yml')
    config.add_required_fields :name, :url, to: :menu

    assert_equal [{ name: 'level1', items: [{ name: 'level2', url: '/' }] }],
                 instance.build(:menu)
  end

  def test_raises_exception_when_field_required_is_not_informed
    config.add_source_path :menu, sources_dir.join('one_level.yml')
    config.add_required_fields :name, :id, to: :menu

    assert_raises LaCarte::RequiredFieldException do
      instance.build :menu
    end
  end

  private

  def instance
    @instance ||= LaCarte::Builder.send(:new)
  end
end
