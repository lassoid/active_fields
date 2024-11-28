# frozen_string_literal: true

module ActiveFields
  # Ruby supports up to 9 fractional seconds, but PostgreSQL, like most databases, supports only 6.
  # Since we use PostgreSQL, we standardize on 6.
  MAX_DATETIME_PRECISION = 6

  # Ruby's BigDecimal class allows extremely high precision,
  # but PostgreSQL supports a maximum of 16383 digits after the decimal point.
  # Since we use PostgreSQL, we limit decimal precision to 16383.
  MAX_DECIMAL_PRECISION = 2**14 - 1
end
