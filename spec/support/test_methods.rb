# frozen_string_literal: true

module TestMethods
  extend self

  def random_string(size = 10)
    charset = Array("A".."Z") + Array("a".."z")
    Array.new(size) { charset.sample }.join
  end

  def random_integer
    rand(-10..10)
  end

  def random_float
    rand(-10.0..10.0)
  end

  def random_decimal
    rand(-10.0..10.0).to_d
  end

  def random_numbers
    [random_integer, random_float, random_decimal]
  end

  def random_number
    random_numbers.sample
  end

  def random_date
    Date.today + random_integer
  end

  def random_active_field_factory
    %i[
      boolean_active_field
      date_active_field
      date_array_active_field
      decimal_active_field
      decimal_array_active_field
      enum_active_field
      enum_array_active_field
      integer_active_field
      integer_array_active_field
      text_active_field
      text_array_active_field
      ip_field
    ].sample
  end

  def active_value_for(active_field)
    case active_field
    when ActiveFields::Field::Text
      min_length = [active_field.min_length, 0].compact.max
      max_length =
        if active_field.max_length && active_field.max_length >= min_length
          active_field.max_length
        else
          min_length + rand(0..10)
        end

      allowed = [random_string(rand(min_length..max_length))]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::TextArray
      min_length = [active_field.min_length, 0].compact.max
      max_length =
        if active_field.max_length && active_field.max_length >= min_length
          active_field.max_length
        else
          min_length + rand(0..10)
        end

      min_size = [active_field.min_size, 0].compact.max
      max_size =
        if active_field.max_size && active_field.max_size >= min_size
          active_field.max_size
        else
          min_size + rand(0..10)
        end

      Array.new(rand(min_size..max_size)) do
        random_string(rand(min_length..max_length))
      end
    when ActiveFields::Field::Enum
      allowed = active_field.allowed_values.dup || []
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::EnumArray
      min_size = [active_field.min_size, 0].compact.max
      max_size =
        if active_field.max_size && active_field.max_size >= min_size
          active_field.max_size
        else
          min_size + rand(0..10)
        end

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

      min_size = [active_field.min_size, 0].compact.max
      max_size =
        if active_field.max_size && active_field.max_size >= min_size
          active_field.max_size
        else
          min_size + rand(0..10)
        end

      Array.new(rand(min_size..max_size)) { rand(min..max) }
    when ActiveFields::Field::Decimal
      min = active_field.min || ((active_field.max || 0) - rand(0.0..10.0))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0.0..10.0)

      allowed = [rand(min..max)]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::DecimalArray
      min = active_field.min || ((active_field.max || 0) - rand(0.0..10.0))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0.0..10.0)

      min_size = [active_field.min_size, 0].compact.max
      max_size =
        if active_field.max_size && active_field.max_size >= min_size
          active_field.max_size
        else
          min_size + rand(0..10)
        end

      Array.new(rand(min_size..max_size)) { rand(min..max) }
    when ActiveFields::Field::Date
      min = active_field.min || ((active_field.max || Date.today) - rand(0..10))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10)

      allowed = [rand(min..max)]
      allowed << nil unless active_field.required?

      allowed.sample
    when ActiveFields::Field::DateArray
      min = active_field.min || ((active_field.max || Date.today) - rand(0..10))
      max = active_field.max && active_field.max >= min ? active_field.max : min + rand(0..10)

      min_size = [active_field.min_size, 0].compact.max
      max_size =
        if active_field.max_size && active_field.max_size >= min_size
          active_field.max_size
        else
          min_size + rand(0..10)
        end

      Array.new(rand(min_size..max_size)) { rand(min..max) }
    when ActiveFields::Field::Boolean
      allowed = [true]
      allowed << false unless active_field.required?
      allowed << nil if active_field.nullable?

      allowed.sample
    when IpField
      allowed = ["127.0.0.1"]
      allowed << nil unless active_field.required?

      allowed.sample
    else
      raise ArgumentError, "undefined active field type"
    end
  end
end
