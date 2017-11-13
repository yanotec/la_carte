module LaCarte
  module Renderer
    autoload :Base, 'la_carte/renderer/base'

    def self.render(name, options = {})
      klass_name = LaCarte::Support.camelize "#{name}_renderer"
      klass = if const_defined?(klass_name) && klass_name != self.to_s
                LaCarte::Support.constantize klass_name
              else
                Base
              end

      klass.render name, options
    end
  end
end
