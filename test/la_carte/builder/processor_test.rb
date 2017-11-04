require 'test_helper'

class LaCarte::Builder::ProcessorTest < LaCarte::TestCase
  module BuilderProcessorPlugin
    def foo; end
  end

  def teardown
    super
    @instance = nil
  end

  def test_include_a_build_processor_plugin
    config.add_source_path :menu, sources_dir.join('empty_menu.yml')

    refute_respond_to instance(:menu), :foo

    config.add_builder_processor BuilderProcessorPlugin
    LaCarte::Builder::Processor.include_plugins!

    assert_respond_to instance, :foo
  end

  def test_build_items_with_one_level
    config.add_source_path :menu, sources_dir.join('one_level.yml')

    assert_equal [ { name: 'home', url: '/' } ], instance(:menu).process
  end

  def test_build_items_with_two_levels
    config.add_source_path :menu, sources_dir.join('two_levels.yml')

    assert_equal(
      [ { name: 'level1', items: [ { name: 'level2', url: '/' } ] } ],
      instance(:menu).process
    )
  end

  def test_build_items_with_three_levels
    config.add_source_path :menu, sources_dir.join('three_levels.yml')

    assert_equal(
      [
        { name: 'level1.1', url: '/level1.1' },
        { name: 'level1.2', items: [ { name: 'level2.1', url: '/level2.1' } ] },
        { name: 'level1.3', items: [
          { name: 'level2.2', items: [ { name: 'level3.1', url: '/level3.1' } ] }
        ] },
      ],
      instance(:menu).process
    )
  end

  private

  def instance(*args)
    @instance ||= LaCarte::Builder::Processor.new(*args)
  end
end
