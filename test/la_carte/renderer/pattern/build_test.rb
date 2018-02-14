require 'test_helper'

class LaCarte::Renderer::Pattern::BuildTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_fill_definitions_when_calls_build
    instance.build do
      set :base do
        div class: 'base'
      end
    end

    assert_equal(
      { base: { all: { content: [ { tag: :div, attributes: { class: 'base' } } ] } } },
      instance.send(:definitions)
    )
  end

  def test_reload_definitions_when_calls_build_many_times
    instance.build do
      set :base do
        div class: 'base'
      end
    end

    assert_equal(
      { base: { all: { content: [ { tag: :div, attributes: { class: 'base' } } ] } } },
      instance.send(:definitions)
    )

    instance.build do
      set :base, :base2, conditions: { base: '2' } do
        div class: 'base2'
      end
    end

    assert_equal(
      { base: { base2: {
        content: [ { tag: :div, attributes: { class: 'base2' } } ],
        conditions: { base: '2' }
      } } },
      instance.send(:definitions)
    )
  end

  def test_fill_definitions_when_calls_bild_with_parallels_content
    instance.build do
      set :base do
        div class: 'base'
        div class: 'base2'
      end
    end

    assert_equal(
      { base: { all: { content: [
        { tag: :div, attributes: { class: 'base' } },
        { tag: :div, attributes: { class: 'base2' } }
      ] } } },
      instance.send(:definitions)
    )
  end

  def test_fill_definitions_when_calls_build_with_parallels_content_in_many_levels
    instance.build do
      set :base do
        div class: 'base' do
          span class: 'level1.1'
          span class: 'level1.2'
        end
      end
    end

    assert_equal(
      { base: { all: { content: [
        { tag: :div, attributes: { class: 'base' } , content: [
          { tag: :span, attributes: { class: 'level1.1' } },
          { tag: :span, attributes: { class: 'level1.2' } }
        ] }
      ] } } },
      instance.send(:definitions)
    )
  end

  def test_fill_definitions_when_calling_build_with_many_set_patterns_of_same_type
    instance.build do
      set :base do
        div class: 'base'
      end

      set :base, :base2, conditions: { base: '2' } do
        div class: 'base2'
      end
    end


    assert_equal(
      {
        base: {
          all: { content: [ { tag: :div, attributes: { class: 'base' } } ] },
          base2: {
            content: [ { tag: :div, attributes: { class: 'base2' } } ],
            conditions: { base: '2' }
          }
        }
      },
      instance.send(:definitions)
    )
  end

  def test_fill_definitions_when_calling_build_with_many_set_patterns_of_different_type
    instance.build do
      set :base do
        div class: 'base'
      end

      set :items do
        ul class: 'items'
      end
    end

    assert_equal(
      {
        base: { all: { content: [ { tag: :div, attributes: { class: 'base' } } ] } },
        items: { all: { content: [ { tag: :ul, attributes: { class: 'items' } } ] } }
      },
      instance.send(:definitions)
    )
  end

  def test_fill_definitions_when_using_a_set_pattern_of_another_existing_type
    instance.build do
      set :base, use: :items
      set :items do
        ul
      end
    end

    assert_equal(
      {
        base: { all: { content: { use: :items } } },
        items: { all: { content: [ { tag: :ul } ] } }
      },
      instance.send(:definitions)
    )
  end

  def test_fill_definitions_when_using_a_set_pattern_of_another_existing_type_between_tags_content
    instance.build do
      set :base do
        div do
          span class: "profile" do
            "Name"
          end
          use :items
        end
      end

      set :items do
        ul
      end
    end

    assert_equal(
      {
        base: { all: { content: [
          { tag: :div, content: [
            { tag: :span, attributes: { class: "profile" }, content: [ "Name" ] },
            { use: :items }
          ] }
        ] } },
        items: { all: { content: [ { tag: :ul } ] } }
      },
      instance.send(:definitions)
    )
  end

  def test_fill_definitions_when_using_a_sub_pattern_between_conditions
    instance.build do
      set :base, use: :items

      set :items do
        ul { use :item }
      end

      set :item do
        li { :content }
      end

      set :item, :selected, conditions: { selected: true } do
        li class: 'selected'
      end

      set :item, :opened, conditions: [:selected, { has: :items }] do
        li class: 'opened'
      end
    end

    assert_equal(
      {
        base: { all: { content: { use: :items } } },
        items: { all: { content: [ { tag: :ul, content: [ { use: :item } ] } ] } },
        item: {
          all: { content: [ { tag: :li, content: [ :content ] } ] },
          selected: {
            content: [ { tag: :li, attributes: { class: 'selected' } } ],
            conditions: { selected: true }
          },
          opened: {
            content: [ { tag: :li, attributes: { class: 'opened' } } ],
            conditions: [ :selected, { has: :items } ]
          }
        }
      },
      instance.send(:definitions)
    )
  end

  def test_exception_raised_when_build_called_without_block
    e = assert_raises LaCarte::RendererError do
      instance.build
    end

    assert_equal "no block given (yield) in build call", e.message
  end

  def test_exception_raised_when_set_called_without_block
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base
      end
    end

    assert_equal "no block given (yield) in set call", e.message
  end

  def test_exception_raised_when_build_called_and_set_does_not_called
    e = assert_raises LaCarte::RendererError do
      instance.build {}
    end

    assert_equal 'no set was used when build pattern was run', e.message
  end

  def test_exception_raised_when_build_and_set_are_called_but_no_changes_definitions
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base do
        end
      end
    end

    assert_equal 'no set was used when build pattern was run', e.message
  end

  def test_exception_raised_when_invalid_html_tag_is_reported_as_method
    assert_raises NoMethodError do
      instance.build do
        set :base do
          aml id: '123'
        end
      end
    end
  end

  def test_exception_raised_when_invalid_html_tag_is_reported_by_content_tag_method
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base do
          content_tag :aml, id: '123'
        end
      end
    end

    assert_equal "undefined tag `aml'", e.message
  end

  def test_exception_raised_when_html_empty_element_is_informed_with_child_node
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base do
          input { span }
        end
      end
    end

    assert_equal "the `input' tag cannot have any child node or content", e.message
  end

  def test_exception_raised_when_html_empty_element_is_informed_with_content
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base do
          input { 'Content text' }
        end
      end
    end

    assert_equal "the `input' tag cannot have any child node or content", e.message
  end

  def test_exception_raised_when_does_not_set_base_pattern
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :items do
          ul
        end
      end
    end

    assert_equal "the pattern :base was not found in definitions", e.message
  end

  def test_exception_raised_when_does_not_set_pattern
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base, use: :items
      end
    end

    assert_equal "the pattern :items was not found in definitions", e.message
  end

  def test_exception_raised_when_calling_set_pattern_more_than_once_after_using_another_type_of_pattern
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base, use: :items
        set :base, :invalid do
          div
        end
      end
    end

    assert_equal "using the `use' clause :base pattern cannot be changed", e.message
  end

  def test_exception_raised_when_calling_set_pattern_more_than_once_before_using_another_type_of_pattern
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base do
          div
        end
        set :base, :invalid, use: :items
      end
    end

    assert_equal "the `use' clause is not allowed for :base pattern because there is another definition", e.message
  end

  def test_exception_raised_when_does_not_set_pattern_between_tag_definition
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base do
          div { use :items }
        end
      end
    end

    assert_equal "the pattern :items was not found in definitions", e.message
  end

  def test_exception_raised_when_does_not_have_subpattern_between_conditions
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base, use: :items

        set :items do
          ul
        end

        set :items, conditions: [:special] do
          ul class: 'special'
        end
      end
    end

    assert_equal "the subpattern :special was not found in :items pattern", e.message
  end

  def test_exception_raised_when_does_not_call_pattern_defined
    e = assert_raises LaCarte::RendererError do
      instance.build do
        set :base do
          ul
        end

        set :items do
          li
        end
      end
    end

    assert_equal "the pattern :items was not related", e.message
  end

  private

  def instance(*args)
    @instance ||= LaCarte::Renderer::Pattern.new(*args)
  end
end
