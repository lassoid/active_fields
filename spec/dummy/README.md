# ActiveFields Dummy App

This app is an example of how to use the `ActiveFields` plugin.

## Quick links

### Active Fields management

- [Controller](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/active_fields_controller.rb)
- [Forms rendering helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/helpers/application_helper.rb#L15)
- [Forms views](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields/forms)
- [Forms usage](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields/new.html.erb#L3)

### Active Values inputs

- [Inputs rendering helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/helpers/application_helper.rb#L21)
- [Inputs views](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields/value_inputs)
- [Inputs usage](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/authors/_form.html.erb#L14)

### Array Active Fields

- [Params normalization helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/application_controller.rb#L12)
- [Params normalization helper usage](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/posts_controller.rb#L59)
- [Array input rendering helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/helpers/application_helper.rb#L4)
- [Array input view](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/shared/_array_input.html.erb)
- [Array input Stimulus controller](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/javascript/controllers/array_input_controller.js)
- [Array input usage](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields/forms/_enum_array.html.erb#L36)

### Custom Active Field Types

- [Model](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/models/ip_field.rb)
- [Type registration](https://github.com/lassoid/active_fields/blob/main/spec/dummy/config/initializers/active_fields.rb)
- [Validator](https://github.com/lassoid/active_fields/blob/main/spec/dummy/lib/ip_validator.rb)
- [Caster](https://github.com/lassoid/active_fields/blob/main/spec/dummy/lib/ip_caster.rb)

### I18n

- [Custom errors localization](https://github.com/lassoid/active_fields/blob/main/spec/dummy/config/locales/en.yml)

## ENV
- `CHANGE_FIELD_BASE_CLASS` - pass any non-blank value to change the Active Fields base class
- `CHANGE_VALUE_CLASS` - pass any non-blank value to change the Active Values class
