require 'test_helper'

class LaCarte::Builder::LoadStoreTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_call_store_values_with_name_builder
    config.add_source_path :menu, sources_dir.join('empty_menu.yml')

    assert_equal [], instance.build(:menu)
  end

  def test_call_store_values_with_a_different_name_builder
    config.add_source_path :menu, sources_dir.join('empty_menu.yml')

    assert_equal [], instance.build(:builder, source: :menu)
  end

  private

  def instance
    @instance ||= LaCarte::Builder.send(:new)
  end
end
