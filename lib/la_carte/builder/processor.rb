module LaCarte
  class Builder::Processor
    include LaCarte::Builder::ProcessorPlugin

    def self.process(*args)
      new(*args).process
    end

    def self.include_plugins!
      LaCarte.config.build_processors.each { |b| self.include b }
      nil
    end

    def initialize(source, current = {})
      self.class.include_plugins!

      self.source = source
      self.values = store[source]['items']
      self.current = current
    end

    def process
      process_items values
    end

    private

    attr_accessor :source, :values, :current

    def process_items(values)
      items = []

      return items unless values.is_a? Array

      values.reject do |value|
        !value.is_a? Hash
      end.each do |value|
        item = process_item(value.dup)

        items << item if item.is_a?(Hash) && item.any?
      end

      items
    end

    def process_item(value)
      item = build_item_by value
      check_required_fields_in item
      check_current_in item
    end

    def store
      LaCarte::Store.store
    end

    def config
      LaCarte.config
    end
  end
end
