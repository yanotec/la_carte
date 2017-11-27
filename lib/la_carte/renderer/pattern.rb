module LaCarte
  module Renderer
    class Pattern
      EMPTY_HTML_ELEMENTS = %i(area base br col embed hr img input keygen link
                               meta params source track wbr).freeze
      HTML_ELEMENTS = %i(a abbr acronym address applet area article aside audio
                        b base basefont bdi bdo bgsound big blink blockquote
                        body br button canvas caption center cite code col
                        colgroup command content data datalist dd del details
                        dfn dialog dir div dl dt element en embed fieldset
                        figcaption figure font footer form frame frameset h1 h2
                        h3 h4 h5 h6 head header hgroup hr html i iframe image
                        img input ins isindex kdb keygen label legend li link
                        listing main map mark marquee menu menuitem meta meter
                        multicol nav nextid nobr noembed noframes noscript
                        object ol optgroup option output p param picture plaintext
                        pre progress q rp rt rtc ruby s samp script section select
                        shadow slot small source spacer span strike strong style
                        sub summary sup table tbody td template textarea tfoot
                        th thead time title tr track tt u ul var video wbr xmp).freeze

      def initialize
        self.definitions = {}
        @set_definitions = false
      end
      alias reload! initialize

      def build(&block)
        reload!
        instance_eval(&block)
        check_definition_set!
      end

      def method_missing(method, *args, &block)
        if HTML_ELEMENTS.include? method.to_sym
          content_tag method.to_sym, *args, &block
        else
          super
        end
      end

      private :reload!
      private

      attr_accessor :definitions

      def check_definition_set!
        unless set_definitions?
          raise LaCarte::RendererError, 'No set was used when build pattern was run'
        end
      end

      def set_definitions?
        !!@set_definitions
      end

      def set(name, pattern_name = :all, options = nil, &block)
        @set_definitions = true
        @__tag_buffer = []

        block.call
        pattern = { tags: @__tag_buffer }

        if options.instance_of?(Hash)
          pattern[:conditions] = options[:conditions] if options[:conditions].any?
        end

        definitions[name.to_sym] ||= {}
        definitions[name.to_sym][pattern_name.to_sym] = pattern
      end

      def content_tag(tag_name, *args, &block)
        unless HTML_ELEMENTS.include? tag_name.to_sym
          raise NoMethodError, "undefined method `#{tag_name}' for #{inspect}"
        end

        tag = { tag: tag_name }

        tag[:attributes] = args.last || Hash.new

        if block
          old_tag_buffer, @__tag_buffer = @__tag_buffer.dup, []

          block.call

          tag[:content] = @__tag_buffer if @__tag_buffer.any?

          @__tag_buffer = old_tag_buffer
        end

        @__tag_buffer << tag

        nil
      end
    end
  end
end
