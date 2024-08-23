# ActiveFields Dummy App

This app is an example of how to use the `ActiveFields` plugin.

## Quick links

### Active Fields management

- [Controller](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/active_fields_controller.rb)
- [Forms views](https://github.com/lassoid/active_fields/tree/main/spec/dummy/app/views/active_fields/new_forms)
- [Forms rendering helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/helpers/application_helper.rb#L12)
- [Forms usage](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields/new.html.erb#L3)

### Active Values inputs

- [Inputs views](https://github.com/lassoid/active_fields/tree/main/spec/dummy/app/views/active_fields/inputs)
- [Inputs rendering helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/helpers/application_helper.rb#L18)
- [Inputs usage](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/authors/_form.html.erb#L14)

### Array Active Fields

- [Params normalization helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/application_controller.rb#L12)
- [Params normalization helper usage](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/posts_controller.rb#L55)
- [Array input view](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/shared/_array_input.html.erb)
- [Array input Stimulus controller](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/javascript/controllers/array_input_controller.js)

### Custom Active Field Types

- [Model](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/models/ip_field.rb)
- [Type registration](https://github.com/lassoid/active_fields/blob/main/spec/dummy/config/initializers/active_fields.rb)
- [Validator](https://github.com/lassoid/active_fields/blob/main/spec/dummy/lib/ip_validator.rb)
- [Caster](https://github.com/lassoid/active_fields/blob/main/spec/dummy/lib/ip_caster.rb)

### I18n

- [Custom errors localization](https://github.com/lassoid/active_fields/blob/main/spec/dummy/config/locales/en.yml#L32)

## ENV
- `CHANGE_FIELD_BASE_CLASS` - pass any non-blank value to change the Active Fields base class
- `CHANGE_VALUE_CLASS` - pass any non-blank value to change the Active Values class
