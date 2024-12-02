# frozen_string_literal: true

class IpArrayField < ActiveFields.config.field_base_class
  acts_as_active_field(
    array: true,
    validator: {
      class_name: "IpArrayValidator",
      options: -> { { min_size: min_size, max_size: max_size } },
    },
    caster: {
      class_name: "IpArrayCaster",
    },
  )
end
