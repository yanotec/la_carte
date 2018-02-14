module LaCarte
  module Renderer
    class Base
      include Inheritance
      include Definition
      extend Translation

      def self.render(*args)
        new(*args).render
      end

      def initialize(opts = nil)
        options = opts.nil? ? {} : opts.dup

        self.builder = options[:builder]
        self.source  = options[:source]  || builder
        self.format  = options[:format]  || :html
        self.current = options[:current] || {}
      end

      def render
      end

      private

      attr_accessor :type, :builder, :source, :format, :current

      def data(force_reload = false)
        LaCarte::Builder.build(
          builder, source: source, force_reload: force_reload, current: current
        )
      end
    end
  end
end
