# frozen_string_literal: true

def Boolean(value)
  ActiveModel::Type::Boolean.new.cast(value)
end
