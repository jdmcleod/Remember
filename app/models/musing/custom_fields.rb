class Musing
  class CustomFields < ActiveRecord::Type::Json
    attr_reader :keys

    def initialize(keys)
      @keys = keys
    end

    def serialize(value)
      return super(value) if value.nil?

      result = fields_for_kind.to_h { |field_name| [field_name, value[field_name]] }

      binding.i rb
      super(result)
    end

    def fields_for_kind
      case kind
      when :book
        [:book, :publish_year]
      else
        [:description]
      end
    end
  end
end
