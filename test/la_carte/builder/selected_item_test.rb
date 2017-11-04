require 'test_helper'

class LaCarte::Builder::CurrentItemTest < LaCarte::TestCase
  def setup
    config.add_source_path :menu, sources_dir.join('selectable.yml')
  end

  def teardown
    super
    @instance = nil
  end

  def test_current_item_when_current_parameters_does_not_match_attributes_of_item
    assert_equal(
      [
        { name: 'level1.1', url: '/level1.1', param1: 'value1', param2: 'value1' },
        { name: 'level1.2', param1: 'value1', param2: 'value2', items: [
          { name: 'level2.1', param1: 'value2', param2: 'value1', url: '/level2.1' }
        ] },
        { name: 'level1.3', param1: 'value1', param2: 'value3', items: [
          { name: 'level2.2', param1: 'value2', param2: 'value2', items: [
            { name: 'level3.1', param1: 'value3', param2: 'value1', url: '/level3.1' }
          ] }
        ] },
      ],
      instance.build(:menu, current: { param1: 'value1', param2: 'value1', params3: 'value1' })
    )
  end

  def test_current_item_when_current_parameters_matches_attributes_of_item_in_first_level
    assert_equal(
      [
        { name: 'level1.1', url: '/level1.1', param1: 'value1', param2: 'value1', selected: true },
        { name: 'level1.2', param1: 'value1', param2: 'value2', items: [
          { name: 'level2.1', param1: 'value2', param2: 'value1', url: '/level2.1' }
        ] },
        { name: 'level1.3', param1: 'value1', param2: 'value3', items: [
          { name: 'level2.2', param1: 'value2', param2: 'value2', items: [
            { name: 'level3.1', param1: 'value3', param2: 'value1', url: '/level3.1' }
          ] }
        ] },
      ],
      instance.build(:menu, current: { param1: 'value1', param2: 'value1' })
    )
  end

  def test_current_item_when_current_parameters_matches_attributes_of_item_in_second_level
    assert_equal(
      [
        { name: 'level1.1', url: '/level1.1', param1: 'value1', param2: 'value1' },
        { name: 'level1.2', param1: 'value1', param2: 'value2', selected: true, items: [
          { name: 'level2.1', param1: 'value2', param2: 'value1', url: '/level2.1', selected: true }
        ] },
        { name: 'level1.3', param1: 'value1', param2: 'value3', items: [
          { name: 'level2.2', param1: 'value2', param2: 'value2', items: [
            { name: 'level3.1', param1: 'value3', param2: 'value1', url: '/level3.1' }
          ] }
        ] },
      ],
      instance.build(:menu, current: { param1: 'value2', param2: 'value1' })
    )
  end

  def test_current_item_when_current_parameters_matches_attributes_of_item_in_third_level
    assert_equal(
      [
        { name: 'level1.1', url: '/level1.1', param1: 'value1', param2: 'value1' },
        { name: 'level1.2', param1: 'value1', param2: 'value2', items: [
          { name: 'level2.1', param1: 'value2', param2: 'value1', url: '/level2.1' }
        ] },
        { name: 'level1.3', param1: 'value1', param2: 'value3', selected: true, items: [
          { name: 'level2.2', param1: 'value2', param2: 'value2', selected: true, items: [
            { name: 'level3.1', param1: 'value3', param2: 'value1', url: '/level3.1', selected: true }
          ] }
        ] },
      ],
      instance.build(:menu, current: { param1: 'value3' })
    )
  end

  private

  def instance
    @instance ||= LaCarte::Builder.send(:new)
  end
end
