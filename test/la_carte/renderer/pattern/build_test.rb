require 'test_helper'

class LaCarte::Renderer::Pattern::BuildTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_exception_raised_when_block_not_informed
    assert_raises ArgumentError do
      instance.build
    end
  end

  def test_exception_raised_when_build_called_and_set_no_called
    e = assert_raises LaCarte::RendererError do
      instance.build {}
    end

    assert_equal 'No set was used when build pattern was run', e.message
  end

  def test_exception_raised_when_no_html_element_tag_is_informed
    assert_raises NoMethodError do
      instance.build do
        set :base do
          aml id: '123'
        end
      end
    end
  end

  def test_build_sets_definitions_when_called
    instance.build do
      set :base do
        div class: 'base'
      end
    end

    assert_equal(
      { base: { all: { tags: [ { tag: :div, attributes: { class: 'base' } } ] } } },
      instance.send(:definitions)
    )
  end

  def test_definitions_reload_when_build_is_called
    instance.build do
      set :base do
        div class: 'base'
      end
    end

    assert_equal(
      { base: { all: { tags: [ { tag: :div, attributes: { class: 'base' } } ] } } },
      instance.send(:definitions)
    )

    instance.build do
      set :base, :base2, conditions: { base: '2' } do
        div class: 'base2'
      end
    end

    assert_equal(
      { base: { base2: {
        tags: [ { tag: :div, attributes: { class: 'base2' } } ],
        conditions: { base: '2' }
      } } },
      instance.send(:definitions)
    )
  end

  def test_build_sets_definitions_with_many_parallels_tags
    instance.build do
      set :base do
        div class: 'base'
        div class: 'separator'
        div class: 'base2'
      end
    end

    assert_equal(
      { base: { all: { tags: [
        { tag: :div, attributes: { class: 'base' } },
        { tag: :div, attributes: { class: 'separator' } },
        { tag: :div, attributes: { class: 'base2' } }
      ] } } },
      instance.send(:definitions)
    )
  end

  def test_build_sets_definitions_with_many_parallels_tags_on_many_levels
    instance.build do
      set :base do
        div class: 'base'
        div class: 'separator'
        div class: 'base2' do
          span class: 'level1.1'
          span class: 'level1.2'
        end
      end
    end

    assert_equal(
      { base: { all: { tags: [
        { tag: :div, attributes: { class: 'base' } },
        { tag: :div, attributes: { class: 'separator' } },
        { tag: :div, attributes: { class: 'base2' } , content: [
          { tag: :span, attributes: { class: 'level1.1' } },
          { tag: :span, attributes: { class: 'level1.2' } }
        ] }
      ] } } },
      instance.send(:definitions)
    )
  end

  def test_build_sets_definitions_with_many_patterns
    instance.build do
      set :base do
        div class: 'base'
      end

      set :base, :base2, conditions: { base: '2' } do
        div class: 'base2'
      end
    end


    assert_equal(
      { base: {
        all: { tags: [ { tag: :div, attributes: { class: 'base' } } ] },
        base2: {
          tags: [ { tag: :div, attributes: { class: 'base2' } } ],
          conditions: { base: '2' }
        }
      } },
      instance.send(:definitions)
    )
  end

  private

  def instance(*args)
    @instance ||= LaCarte::Renderer::Pattern.new(*args)
  end
end
