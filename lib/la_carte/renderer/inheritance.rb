module LaCarte
  module Renderer
    module Inheritance
      extend LaCarte::Support::Concern

      module ClassMethods
        # Returns the class descending directly from LaCarte::Renderer::Base,
        # if any, in the inheritance hierarchy.
        #
        # If A extends LaCarte::Renderer::Base, A.base_class will return A.
        # If B descends from A through some arbitrarily deep hierarchy,
        # B.base_class will return A.
        #
        # If B < A and C < B then both B.base_class and C.base_class would
        # return A.
        def base_class
          unless self < Base
            raise LaCarte::RendererError, "#{name} doesn't belong in a hierarchy descending from LaCarte::Renderer"
          end

          if superclass == Base
            self
          else
            superclass.base_class
          end
        end

        def class_name
          name = LaCarte::Support.demodulize(self)
          name = LaCarte::Support.underscore(name)

          self == Base ? "#{name}_class" : name.gsub(/_renderer\z/, '')
        end
      end
    end
  end
end
