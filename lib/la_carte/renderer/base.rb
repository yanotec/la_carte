module LaCarte
  module Renderer
    class Base
      include Inheritance
      include Definition
      extend Translation

      def self.render
      end
    end
  end
end
