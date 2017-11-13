module LaCarte
  class Configuration
    class << self
      private :new

      def configure(&block)
        instance.configure(&block)
      end

      def instance
        Thread.current['la_carte_config'] ||= new
      end
    end

    def initialize
      @load_paths = {}
      @build_processors = []
      @required_fields = {}
    end

    def configure(&block)
      instance_eval(&block)
    end

    def config
      self
    end

    def load_paths(source)
      @load_paths[source].dup
    end

    def build_processors
      @build_processors.dup
    end

    def required_fields(source)
      @required_fields.dup[source] || []
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

    def add_builder_processor(builder)
      if builder.instance_of? Array
        builder.each {|b| add_builder_processor b }
        return true
      elsif builder.is_a? String
        begin
          add_builder_processor LaCarte::Support.constantize builder
          return true
        rescue NameError
        end
      end

      if builder.is_a?(Class) || !builder.is_a?(Module)
        raise NoModuleException
      elsif @build_processors.include? builder
        raise DuplicityBuilderException.new builder
      end

      @build_processors << builder

      true
    end

    def add_required_fields(*fields)
      options = fields.last.instance_of?(Hash) ? fields.pop : {}
      source = :"#{options[:to]}"

      if fields.empty?
        raise ArgumentError, 'wrong number of arguments (given 0, expected 1+)'
      elsif !@load_paths.has_key? source
        raise NoSourceException, source.inspect
      end

      @required_fields[source] ||= []
      @required_fields[source] += fields
      @required_fields[source].uniq!

      true
    end

    def inspect
      "#<#{self.class}>"
    end
  end
end
