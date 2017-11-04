module LaCarte
  class Store
    class << self
      private :new

      def store
        Thread.current[:la_carte_store] ||= new
      end
    end

    def initialize
      reload!
    end

    def [](key)
      source = :"#{key}"

      load_data_by source
      stored_data[source]
    end

    def inspect
      "#<#{self.class}>"
    end

    def reload!
      @stored_data = Hash.new { |h, f| h[f] = {} }
    end

    private

    def config
      LaCarte.config
    end

    def stored_data
      @stored_data.dup
    end

    def load_data_by(source)
      return unless stored_data[source].empty?

      begin
        filename = config.load_paths(source)
        type     = File.extname(filename).tr('.', '').downcase
      rescue TypeError
        raise UnknownSourcePathException.new source
      end

      begin
        data = send(:"load_#{type}", filename)
      rescue ScriptError, StandardError => e
        raise InvalidSintaxDataException.new filename, e.message
      end

      raise InvalidSintaxDataException.new filename unless data.is_a?(Hash)

      @stored_data[source] = data
    end

    def load_rb(filename)
      eval(IO.read(filename), binding, filename)
    end

    def load_yml(filename)
      require 'yaml'

      YAML.load_file(filename)
    end
  end
end
