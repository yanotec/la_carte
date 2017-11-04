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
      @build_processors = []
      @required_fields = {}
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
          add_builder_processor constantize builder
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

    private

    def constantize(module_name)
      names = module_name.split("::".freeze)

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(module_name) if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject(constant) do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end
  end
end
