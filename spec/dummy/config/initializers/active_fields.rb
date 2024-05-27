# frozen_string_literal: true

ActiveFields.configure do |config|
  # TODO: add specs for app with configured classes
  config.field_class = "CustomField" if ENV["CHANGE_FIELD_CLASS"]
  config.field_class = "CustomValue" if ENV["CHANGE_VALUE_CLASS"]
  config.register_field :ip, "IpField"
end
