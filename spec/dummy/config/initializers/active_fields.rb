# frozen_string_literal: true

ActiveFields.configure do |config|
  config.field_base_class_name = "CustomField" if ENV["CHANGE_FIELD_BASE_CLASS"].present?
  config.value_class_name = "CustomValue" if ENV["CHANGE_VALUE_CLASS"].present?

  config.register_field :ip, "IpField"
end
