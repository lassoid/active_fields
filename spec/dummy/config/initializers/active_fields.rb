# frozen_string_literal: true

ActiveFields.configure do |config|
  config.field_base_class = "CustomField" if ENV["CHANGE_FIELD_BASE_CLASS"] == "true"
  config.value_class = "CustomValue" if ENV["CHANGE_VALUE_CLASS"] == "true"

  config.register_field :ip, "IpField"
end
