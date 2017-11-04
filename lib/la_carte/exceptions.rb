module LaCarte
  class Exception < ::RuntimeError; end

  class DuplicitySourceException < Exception
    def initialize(source, message = nil)
      message ||= "The source (#{source}) has already been added. Verify that the source is correct."
      super message
    end
  end

  class DuplicityPathException < Exception
    def initialize(filename, message = nil)
      message ||= "The filename (#{filename}) has already been added. Verify that the filename is correct."
      super message
    end
  end

  class UnknownFileTypeException < Exception
    def initialize(filename, message = nil)
      allowed_types = ALLOWED_TYPES.dup
      types = allowed_types.pop
      types = "#{allowed_types.join(", ")} and #{types}"

      message ||= "File (#{filename}) not allowed, only files with #{types} extension are allowed."

      super message
    end
  end

  class NonexistFileException < Exception
    def initialize(filename, message = nil)
      message ||= "cannot load such file -- #{filename}"

      super message
    end
  end
end
