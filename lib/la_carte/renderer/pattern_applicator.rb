module LaCarte
  module Renderer
    module PatternApplicator
      def apply(items, type = :base)
        item = { items: items }
        apply_definitions item, :base
      end

      private

      def apply_definitions(item, type)
        if type == :item
          item[:items].collect do |subitem|
            apply_content subitem, get_content(type, subitem)
          end
        else
          apply_content item, get_content(type, item)
        end
      end

      def get_content(type, item)
        definition = definitions[type].dup

        content = (definition.delete(:all) || { content: [] })[:content]

        return content if content.is_a? Hash

        definition.each do |_, pattern|
          content = pattern[:content]
        end

        content
      end

      def apply_content(item, content)
        if content.is_a?(Hash) && content[:use]
          return apply_definitions item, content[:use]
        end

        result = []

        content.each_with_index do |tag, i|
          result[i] = if tag.is_a? Hash
                        if tag.has_key? :use
                          apply_definitions item, tag[:use]
                        else
                          element = {}

                          tag.each do |key, value|
                            case key
                            when :tag then
                              element[key] = value
                            when :attributes then
                              attrs = {}

                              value.each do |k, v|
                                has_subitems = item[:items] && item[:items].any?
                                attrs[k] = if v == :url && has_subitems
                                             '#'
                                             else
                                               apply_value(item, v)
                                             end
                              end

                              element[key] = attrs
                            when :content then
                              element[key] = apply_content item, value
                            end
                          end

                          element
                        end
                      else
                        apply_value(item, tag)
                      end

          result.flatten!
        end

        result
      end

      def apply_value(item, key)
        case key
        when Symbol then
          item[key] || key.to_s
        when String then
          key
        when Array then
          key.map {|k| apply_value item, k }.join(" ")
        else
          key
        end
      end
    end
  end
end
