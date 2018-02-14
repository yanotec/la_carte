module LaCarte
  module Renderer
    class Simple < Base
      define_pattern do
        set :base, use: :items

        set :items do
          ul class: 'menu' do
            use :item
          end
        end

        set :item do
          li do
            a href: :url do
              :content
            end
          end
        end

        set :item, :selected, conditions: { selected: true } do
          li class: 'selected' do
            a href: :url do
              :content
            end
          end
        end

        set :item, :subitems, conditions: { has: :items } do
          li do
            a href: '#' do
              :content
            end
            use :items
          end
        end

        set :item, :opened, conditions: [:selected, :subitems] do
          li class: 'opened'
        end
      end
    end
  end
end
