require 'test_helper'

class LaCarte::Renderer::Pattern::ApplyTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_apply_pattern_in_the_base_definition
    instance.build do
      set :base do
        div class: :base
      end
    end

    assert_equal(
      [ { tag: :div, attributes: { class: 'base' } } ],
      instance.apply(data)
    )
  end

  def test_apply_pattern_in_the_items_definition
    instance.build do
      set :base, use: :items
      set :items do
        div class: :base do
          span { "Name" }
          ul
        end
      end
    end

    assert_equal(
      [
        { tag: :div, attributes: { class: 'base' }, content: [
          { tag: :span, content: [ "Name" ] }, { tag: :ul }
        ] }
      ],
      instance.apply(data)
    )
  end

  def test_apply_pattern_in_the_item_definition
    instance.build do
      set :base, use: :items
      set :items do
        div class: :base do
          span { "Name" }
          ul { use :item }
        end
      end

      set :item do
        li do
          a href: :url do
            :name
          end
        end
      end
    end

    assert_equal(
      [
        { tag: :div, attributes: { class: 'base' }, content: [
          { tag: :span, content: [ "Name" ] },
          { tag: :ul, content: [
            { tag: :li, content: [
              { tag: :a, attributes: { href: '/level1.1' }, content: ['level1.1']}
            ] },
            { tag: :li, content: [
              { tag: :a, attributes: { href: '#' }, content: ['level1.2']}
            ] },
            { tag: :li, content: [
              { tag: :a, attributes: { href: '#' }, content: ['level1.3']}
            ] },
          ] }
        ] }
      ],
      instance.apply(data)
    )
  end

  private

  def instance(*args)
    @instance ||= LaCarte::Renderer::Pattern.new(*args)
  end

  def data
    [
      { name: "level1.1", param1: "value1", param2: "value1", url: "/level1.1" },
      { name: "level1.2", param1: "value1", param2: "value2", items: [
        { name: "level2.1", param1: "value2", param2: "value1", url: "/level2.1" }
      ] },
      { name: "level1.3", param1: "value1", param2: "value3", items: [
        { name: "level2.2", param1: "value2", param2: "value2", items: [
          { name: "level3.1", param1: "value3", param2: "value1", url: "/level3.1",
            selected: true }
        ], selected: true }
      ], selected: true }
    ]
  end
end