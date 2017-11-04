require "la_carte/version"
require "la_carte/exceptions"

module LaCarte
  ALLOWED_TYPES = %w(.yml .rb).freeze

  autoload :Configuration, 'la_carte/configuration'
  autoload :Store,         'la_carte/store'
  autoload :Builder,       'la_carte/builder'

  # Default way to configure LaCarte.
  def self.configure(&block)
    Configuration.configure(&block)
  end

  def self.config
    Configuration.instance
  end
end
