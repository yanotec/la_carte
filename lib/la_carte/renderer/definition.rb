module LaCarte
  module Renderer
    module Definition
      extend LaCarte::Support::Concern

      module ClassMethods
        def define_pattern(&block)
          pattern.build(&block)
          nil
        end

        def pattern
          Thread.current[:"la_carte_renderer_#{class_name}"] ||= Pattern.new
        end
      end
    end
  end
end
