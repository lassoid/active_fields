# frozen_string_literal: true

module TestMethods
  extend self

  def random_string(size = 10)
    charset = Array("\x20".."\x7E")
    Array.new(size) { charset.sample }.join
  end

  def random_integer
    rand(-10..10)
  end

  def random_float
    rand(-10.0..10.0)
  end

  def random_decimal(precision = 16)
    BigDecimal("#{random_integer}.#{Array.new(precision - 1) { rand(0..9) }.join}#{rand(1..9)}", 0)
  end

  def random_numbers
    [random_integer, random_float, random_decimal]
  end

  def random_number
    random_numbers.sample
  end

  def random_date
    Date.current + random_integer.days
  end

  def random_datetime
    Time.current + random_integer.days
  end

  def apply_datetime_precision(value, precision)
    number_of_insignificant_digits = 9 - precision
    round_power = 10**number_of_insignificant_digits
    rounded_off_nsec = value.nsec % round_power

    value.change(nsec: value.nsec - rounded_off_nsec)
  end

  def dummy_models
    [Author, Post] # Group doesn't have Active Fields
  end

  def customizable_models_for(active_field_class_name)
    dummy_models.select do |model|
      model.allowed_active_fields_class_names.include?(active_field_class_name)
    end
  end

  def active_field_factories_for(customizable_model)
    active_field_factory_mappings.values_at(
      *customizable_model.allowed_active_fields_class_names,
    )
  end

  def random_active_field_factory
    active_field_factory_mappings.values.sample
  end

  def active_field_factory_mappings
    {
      "ActiveFields::Field::Boolean" => :boolean_active_field,
      "ActiveFields::Field::Date" => :date_active_field,
      "ActiveFields::Field::DateArray" => :date_array_active_field,
      "ActiveFields::Field::DateTime" => :datetime_active_field,
      "ActiveFields::Field::DateTimeArray" => :datetime_array_active_field,
      "ActiveFields::Field::Decimal" => :decimal_active_field,
      "ActiveFields::Field::DecimalArray" => :decimal_array_active_field,
      "ActiveFields::Field::Enum" => :enum_active_field,
      "ActiveFields::Field::EnumArray" => :enum_array_active_field,
      "ActiveFields::Field::Integer" => :integer_active_field,
      "ActiveFields::Field::IntegerArray" => :integer_array_active_field,
      "ActiveFields::Field::Text" => :text_active_field,
      "ActiveFields::Field::TextArray" => :text_array_active_field,
      "IpField" => :ip_field,
      "IpArrayField" => :ip_array_field,
    }
  end

  def active_value_factory
    ActiveFields.config.value_class_changed? ? :custom_value : :active_value
  end

  def active_value_for(active_field)
    case active_field
    when ActiveFields::Field::Boolean
      allowed = [true]
      allowed << false unless active_field.required?
      allowed << nil if active_field.nullable?

      allowed.sample
    when ActiveFields::Field::Date
      min = active_field.min || ((active_field.max || Date.current) - rand(0..10).days)
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10).days

      allowed = [rand(min..max)]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::DateArray
      min = active_field.min || ((active_field.max || Date.current) - rand(0..10).days)
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10).days

      min_size, max_size = minmax_sizes(active_field)

      Array.new(rand(min_size..max_size)) { rand(min..max) }
    when ActiveFields::Field::DateTime
      min = active_field.min || ((active_field.max || Time.current) - rand(0..10).days)
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10).days
      precision = [active_field.precision, ActiveFields::MAX_DATETIME_PRECISION].compact.min

      allowed = [apply_datetime_precision(rand(min..max), precision)]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::DateTimeArray
      min = active_field.min || ((active_field.max || Time.current) - rand(0..10).days)
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10).days
      precision = [active_field.precision, ActiveFields::MAX_DATETIME_PRECISION].compact.min

      min_size, max_size = minmax_sizes(active_field)

      Array.new(rand(min_size..max_size)) { apply_datetime_precision(rand(min..max), precision) }
    when ActiveFields::Field::Decimal
      min = active_field.min || ((active_field.max || 0) - rand(0.0..10.0))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0.0..10.0)
      precision = [active_field.precision, ActiveFields::MAX_DECIMAL_PRECISION].compact.min

      allowed = [rand(min..max).truncate(precision)]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::DecimalArray
      min = active_field.min || ((active_field.max || 0) - rand(0.0..10.0))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0.0..10.0)
      precision = [active_field.precision, ActiveFields::MAX_DECIMAL_PRECISION].compact.min

      min_size, max_size = minmax_sizes(active_field)

      Array.new(rand(min_size..max_size)) { rand(min..max).truncate(precision) }
    when ActiveFields::Field::Enum
      allowed = active_field.allowed_values.dup || []
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::EnumArray
      min_size, max_size = minmax_sizes(active_field)

      active_field.allowed_values&.sample(rand(min_size..max_size)) || []
    when ActiveFields::Field::Integer
      min = active_field.min || ((active_field.max || 0) - rand(0..10))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10)

      allowed = [rand(min..max)]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::IntegerArray
      min = active_field.min || ((active_field.max || 0) - rand(0..10))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10)

      min_size, max_size = minmax_sizes(active_field)

      Array.new(rand(min_size..max_size)) { rand(min..max) }
    when ActiveFields::Field::Text
      min_length, max_length = minmax_lengths(active_field)

      allowed = [random_string(rand(min_length..max_length))]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::TextArray
      min_length, max_length = minmax_lengths(active_field)
      min_size, max_size = minmax_sizes(active_field)

      Array.new(rand(min_size..max_size)) do
        random_string(rand(min_length..max_length))
      end
    when IpField
      allowed = [Array.new(4) { rand(256) }.join(".")]
      allowed << nil unless active_field.required?

      allowed.sample
    when IpArrayField
      min_size, max_size = minmax_sizes(active_field)

      Array.new(rand(min_size..max_size)) do
        Array.new(4) { rand(256) }.join(".")
      end
    else
      raise ArgumentError, "undefined active field type `#{active_field.inspect}`"
    end
  end

  private

  def minmax_sizes(active_field)
    min_size = [active_field.min_size, 0].compact.max
    max_size =
      if active_field.max_size && active_field.max_size >= min_size
        active_field.max_size
      else
        min_size + rand(0..10)
      end

    [min_size, max_size]
  end

  def minmax_lengths(active_field)
    min_length = [active_field.min_length, 0].compact.max
    max_length =
      if active_field.max_length && active_field.max_length >= min_length
        active_field.max_length
      else
        min_length + rand(0..10)
      end

    [min_length, max_length]
  end
end
