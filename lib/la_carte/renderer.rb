module LaCarte
  module Renderer
    autoload :Base,              'la_carte/renderer/base'
    autoload :Pattern,           'la_carte/renderer/pattern'
    autoload :PatternApplicator, 'la_carte/renderer/pattern_applicator'
    autoload :PatternBuilder,    'la_carte/renderer/pattern_builder'
    autoload :Definition,        'la_carte/renderer/definition'
    autoload :Inheritance,       'la_carte/renderer/inheritance'
    autoload :Translation,       'la_carte/renderer/translation'

    def self.render(name, opts = nil)
      options = (opts.nil? ? {} : opts.dup)
      options[:builder] ||= name

      names = [name, options.delete(:type), 'renderer'].reject{ |n| n.to_s == '' }
      klass_name = LaCarte::Support.camelize names.join('_')

      klass = if const_defined?(klass_name) && klass_name != self.to_s
                LaCarte::Support.constantize klass_name
              else
                Base
              end

      klass.render options
    end
  end
end
