module LaCarte
  module Renderer
    class Base
      include Inheritance
      include Definition
      extend Translation

      def self.render(*args)
        new(*args).render
      end

      def render
      end
    end
  end
end
