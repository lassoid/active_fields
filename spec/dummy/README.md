# ActiveFields Dummy App

This app is an example of how to use the `ActiveFields` plugin.

## Quick links

### Basic

- [Active Fields controller](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/active_fields_controller.rb)
- [Active Fields views](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields)
- [Customizable controller](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/controllers/posts_controller.rb)
- [Customizable form](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/posts/_form.html.erb)
- [Helper](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/helpers/application_helper.rb)
- [Active Fields forms](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields/forms)
- [Active Values inputs](https://github.com/lassoid/active_fields/blob/main/spec/dummy/app/views/active_fields/values/inputs)

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
