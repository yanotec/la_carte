module LaCarte
  module Renderer
    class Pattern
      def build(&block)
        instance_eval(&block)
      end
    end
  end
end
