module LaCarte
  module Support
    module Concern
      def included(base)
        base.extend const_get(:ClassMethods) if const_defined?(:ClassMethods)
      end
    end

    extend self

    def camelize(term, uppercase_first_letter = true)
      string = term.to_s
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
      else
        string = string.sub(/^(?:(?-mix:(?=a)b)(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
      end
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      string.gsub!("/".freeze, "::".freeze)
      string
    end

    def constantize(module_name)
      names = module_name.split("::".freeze)

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(module_name) if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject(constant) do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

    def underscore(camel_cased_word)
      return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)
      word = camel_cased_word.to_s.gsub("::".freeze, "/".freeze)
      word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)((?-mix:(?=a)b))(?=\b|[^a-z])/) { "#{$1 && '_'.freeze }#{$2.downcase}" }
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
      word.tr!("-".freeze, "_".freeze)
      word.downcase!
      word
    end

    def humanize(lower_case_and_underscored_word, options = {})
      result = lower_case_and_underscored_word.to_s.dup

      result.sub!(/\A_+/, "".freeze)
      result.sub!(/_id\z/, "".freeze)
      result.tr!("_".freeze, " ".freeze)

      result.gsub!(/([a-z\d]*)/i) do |match|
        "#{match.downcase}"
      end

      if options.fetch(:capitalize, true)
        result.sub!(/\A\w/) { |match| match.upcase }
      end

      result
    end

    def demodulize(path)
      path = path.to_s
      if i = path.rindex("::")
        path[(i + 2)..-1]
      else
        path
      end
    end
  end
end
