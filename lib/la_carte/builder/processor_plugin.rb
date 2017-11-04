module LaCarte
  module Builder::ProcessorPlugin
    private

    def build_item_by(value)
      item = {}

      subitems = process_items value.delete('items')

      value.each do |k, v|
        next if ['url', :url].include?(k) && subitems.any?

        item[:"#{k}"] = v
      end

      item[:items] = subitems if subitems.any?

      item
    end

    def check_required_fields_in(item)
      keys = item.keys

      config.required_fields(source).each do |f|
        field = f.to_sym

        next if field == :items
        next if field == :url && item.has_key?(:items)

        if !keys.include?(field)
          raise LaCarte::RequiredFieldException, field
        end
      end

      item
    end

    def check_current_in(item)
      selected = []

      current.each do |field, value|
        selected << (item[field] == value)
      end

      if selected.all? && selected.any?
        item[:selected] = true
      elsif item.has_key?(:items)
        item[:items].each do |subitem|
          next unless subitem[:selected]

          item[:selected] = true
          break
        end
      end

      item
    end
  end
end
