module LaCarte
  module Renderer
    module Translation
      # set the lookup ancestors for LaCarte::Renderer.
      def lookup_ancestors #:nodoc:
        klass = self
        classes = [klass]

        return classes if klass == LaCarte::Renderer::Base

        while klass != klass.base_class
          classes << klass = klass.superclass
        end

        classes
      end

      # Set the i18n scope to overwrite ActiveModel.
      def i18n_scope #:nodoc:
        :la_carte
      end

      def i18n_key
        term = if self == Base
                 'Base'
               else
                 name.gsub(/Renderer$/, '')
               end

        LaCarte::Support.underscore(term).to_sym
      end

      def human(type, opts = nil)
        options = (opts.nil? ? {} : opts.dup)
        name = type.dup.to_s.split('.').first
        renderer_scope = "#{i18n_scope}.renderer"

        defaults = lookup_ancestors.map do |klass|
          :"#{renderer_scope}.#{klass.i18n_key}.#{name}"
        end

        defaults << :"#{renderer_scope}.#{name}"
        defaults << options.delete(:default).to_s if options[:default]
        defaults << LaCarte::Support.humanize(name)

        options[:default] = defaults

        I18n.translate(defaults.shift, options)
      end
    end
  end
end
