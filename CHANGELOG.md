## [Unreleased]
- Drop support for Rails < 7 (EOL)
- Drop support for Ruby < 3.1 (EOL)

**Breaking changes**:
- Maximum datetime precision reduced to 6 for all _Ruby_/_Rails_ versions.

    While _Ruby_ allows up to 9 fractional seconds, most databases, including _PostgreSQL_, support only 6.
    To ensure compatibility and prevent potential issues,
    we are standardizing the precision to the minimum supported across our technology stack.

- Maximum datetime precision constant relocated.

    The maximum precision value has been moved
    from `ActiveFields::Casters::DateTimeCaster::MAX_PRECISION` to `ActiveFields::MAX_DATETIME_PRECISION`.

- Maximum decimal precision set to to 16383 (2**14 - 1).

    While _Ruby_'s `BigDecimal` class allows extremely high precision,
    PostgreSQL supports a maximum of 16383 digits after the decimal point.
    To ensure compatibility, we are capping the precision at this value.
    The maximum precision value is now accessible via `ActiveFields::MAX_DECIMAL_PRECISION`.

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
