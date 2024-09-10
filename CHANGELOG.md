## [Unreleased]

## [1.1.0] - 2024-09-10
- Added scaffold generator
- Disabled models reloading to prevent STI issues

## [1.0.0] - 2024-09-07
- Precision configuration for decimal fields
- Added array field types mix-in `ActiveFields::FieldArrayConcern`
- Fixed enum types behavior for blank values
- Dummy app
- Enhanced values storage format
- Do not implicitly create _Active Values_ when saving an _Active Field_ or _Customizable_
- Utilize _ActiveRecord_'s nested attributes feature in _Customizable_ models to manage associated _Active Values_
- Serialize decimals as strings as _ActiveRecord_ does for JSON columns
- Added datetime and datetime array field types
- Added fields configuration DSL
- Introduced new _Customizable_ setter for _Active Values_ (`active_fields_attributes=`) with a more convenient syntax
    to replace the default setter (`active_values_attributes=`) from Rails nested attributes feature.

## [0.2.0] - 2024-06-13

- Rewritten as a Rails plugin!
- Custom field types support
- Global configuration options for changing field and value classes
- Per-model configuration option for enabling specific field types only

## [0.1.0] - 2024-05-19

- Initial release
