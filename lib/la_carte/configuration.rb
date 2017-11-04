module LaCarte
  class Configuration
    class << self
      private :new

      def configure
        yield instance
      end

      def instance
        Thread.current['la_carte_config'] ||= new
      end
    end

    def initialize
      @load_paths = {}
    end

    def load_paths(source)
      @load_paths[source].dup
    end

    def add_source_path(source, path)
      source = :"#{source}"
      path   = Pathname.new "#{path}"

      if !path.exist?
        raise NonexistFileException.new path
      elsif !ALLOWED_TYPES.include? path.extname
        raise UnknownFileTypeException.new path
      elsif @load_paths.has_key? source
        raise DuplicitySourceException.new source
      elsif @load_paths.has_value? path.to_s
        raise DuplicityPathException.new path
      end

      @load_paths[source] = path.to_s

      true
    end

    def inspect
      "#<#{self.class}>"
    end
  end
end
