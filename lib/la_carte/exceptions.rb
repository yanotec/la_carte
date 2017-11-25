module LaCarte
  class Exception < ::RuntimeError; end

  class RendererError < Exception; end

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

  class UnknownSourcePathException < Exception
    def initialize(source, message = nil)
      message ||= "undefined source_path `#{source}` for LaCarte.configure"

      super message
    end
  end

  class InvalidSintaxDataException < Exception
    def initialize(filename, message = nil)
      message ||= "(#{filename}) expects it returns a hash, but did not occur."

      super message
    end
  end

  class NoModuleException < Exception
    def initialize(message = nil)
      message ||= "Expected to receive a module."

      super message
    end
  end

  class DuplicityBuilderException < Exception
    def initialize(builder, message = nil)
      message ||= "Builder #{builder} has already been added to the list"

      super message
    end
  end

  class NoSourceException < Exception
    def initialize(source, message = nil)
      message ||= "The source (#{source}) was not found. Verify that the source is correct or defined."
      super message
    end
  end

  class RequiredFieldException < Exception
    def initialize(field, message = nil)
      message ||= "The field (#{field}) is_required."

      super message
    end
  end
end
