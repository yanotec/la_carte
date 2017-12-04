module LaCarte
  module Renderer
    module PatternBuilder
      def initialize
        @set_definitions = false
      end

      def build(&block)
        reload!
        instance_eval(&block)
        check_definition_set!
      rescue ArgumentError => e
        if e.message == "wrong number of arguments (given 0, expected 1..3)"
          raise LaCarte::RendererError, 'no block given (yield) in build call'
        else
          raise e
        end
      end

      def method_missing(method, *args, &block)
        if Pattern::HTML_ELEMENTS.include? method.to_sym
          content_tag method.to_sym, *args, &block
        else
          super
        end
      end

      private

      def check_definition_set!
        if not set_definitions?
          raise LaCarte::RendererError, 'no set was used when build pattern was run'
        elsif not definitions.has_key? :base
          raise LaCarte::RendererError, 'the pattern :base was not found in definitions'
        else
          definitions.each do |type, definition|
            check_definition_reference_in_conditions type, definition
            definition.each do |name, pattern|
              content = (pattern || {})[:content]
              check_definition_reference_in_content type, name, content
            end
          end
        end
      end

      def check_definition_reference_in_conditions(type, pattern)
        pattern.each do |_, definition|
          next unless definition
          next unless definition[:conditions].is_a? Array

          definition[:conditions].each do |condition|
            next unless condition.is_a? Symbol

            if not pattern[condition]
              raise LaCarte::RendererError, "the subpattern #{condition.inspect} was not found in #{type.inspect} pattern"
            end
          end
        end
      end

      def check_definition_reference_in_content(type, name, content)
        return unless content.is_a?(Hash) || content.is_a?(Array)

        other_type = nil

        if name == :all && content.is_a?(Hash) && content[:use]
          other_type = content[:use]
        elsif content.is_a? Array
          content.each do |tag|
            next unless tag.is_a? Hash
            next unless tag[:use] || tag[:content]

            if (other_type = tag[:use])
              break
            else
              check_definition_reference_in_content type, name, tag[:content]
            end
          end
        end

        if other_type && definitions[other_type].nil?
          raise LaCarte::RendererError, "the pattern #{other_type.inspect} was not found in definitions"
        end
      end

      def set_definitions?
        !!@set_definitions
      end

      def set(type, pattern_name = :all, opts = nil)
        opts, pattern_name = pattern_name, :all if pattern_name.instance_of? Hash
        options = (opts.instance_of?(Hash) ? opts : Hash.new)
        type = type.to_sym
        pattern_name = pattern_name.to_sym

        pattern = Hash.new
        definitions[type] ||= {}

        if options.has_key? :use
          if definitions[type].any?
            raise LaCarte::RendererError, "the `use' clause is not allowed for #{type.inspect} pattern because there is another definition"
          end

          pattern[:content] = { use: options[:use] }

          @set_definitions = true
        else
          if definitions[type][:all] && definitions[type][:all][:content].is_a?(Hash)
            raise LaCarte::RendererError, "using the `use' clause #{type.inspect} pattern cannot be changed"
          end

          @__tag_buffer = []

          begin
            yield
          rescue LocalJumpError => e
            raise LaCarte::RendererError, "#{e.message} in set call"
          end

          pattern[:content] = @__tag_buffer
          if (options[:conditions] || []).any?
            pattern[:conditions] = options[:conditions]
          end
        end

        definitions[type.to_sym][pattern_name.to_sym] = pattern

        nil
      end

      def content_tag(tag_name, *args)
        unless Pattern::HTML_ELEMENTS.include? tag_name.to_sym
          raise LaCarte::RendererError, "undefined tag `#{tag_name}'"
        end

        @set_definitions = true

        tag = { tag: tag_name }

        if not (tag_attributes = args.last).nil?
          tag[:attributes] = tag_attributes
        end

        if block_given?
          old_tag_buffer, @__tag_buffer = @__tag_buffer.dup, []

          content_text = yield

          case content_text
          when String, Symbol then
            @__tag_buffer << content_text
          when Numeric, TrueClass, FalseClass then
            @__tag_buffer << content_text.to_s
          end

          if @__tag_buffer.any?
            if Pattern::EMPTY_HTML_ELEMENTS.include? tag_name.to_sym
              @__tag_buffer = old_tag_buffer # returns old buffer value
              raise LaCarte::RendererError, "the `#{tag_name}' tag cannot have any child node or content"
            end
            tag[:content] = @__tag_buffer
          end

          @__tag_buffer = old_tag_buffer
        end

        @__tag_buffer << tag

        nil
      end

      def use(type)
        @__tag_buffer << { use: type }

        nil
      end
    end
  end
end
