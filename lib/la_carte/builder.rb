module LaCarte
  class Builder
    autoload :Processor, 'la_carte/builder/processor'
    autoload :ProcessorPlugin, 'la_carte/builder/processor_plugin'

    class << self
      def build(*args)
        instance.build(*args)
      end

      private :new
      private

      def instance
        Thread.current[:la_carte_builder] ||= new
      end
    end

    def initialize
      @data = {}
    end

    def build(name, opts = nil)
      options = opts.nil? ? {} : opts.dup

      force_reload = options.delete(:force_reload) || false
      source  = options.delete(:source) || name
      current = options.delete(:current) || {}

      build_data_by(name, force_reload, source, current)

      data[name]
    end

    private

    def build_data_by(name, force_reload, source, current)
      @data[name] = nil if force_reload
      @data[name] ||= Processor.process source, current
    end

    def data
      @data.dup
    end
  end
end
