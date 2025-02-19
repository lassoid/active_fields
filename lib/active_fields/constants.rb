# frozen_string_literal: true

module ActiveFields
  # Ruby supports up to 9 fractional seconds, but PostgreSQL, like most databases, supports only 6.
  # Since we use PostgreSQL, we standardize on 6.
  MAX_DATETIME_PRECISION = 6

  # Ruby's BigDecimal class allows extremely high precision,
  # but PostgreSQL supports a maximum of 16383 digits after the decimal point.
  # Since we use PostgreSQL, we limit decimal precision to 16383.
  MAX_DECIMAL_PRECISION = 2**14 - 1

  OPS = {
    eq: :"=",
    not_eq: :"!=",
    gt: :">",
    gteq: :">=",
    lt: :"<",
    lteq: :"<=",

    start_with: :"^",
    end_with: :"$",
    contain: :"~",
    not_start_with: :"!^",
    not_end_with: :"!$",
    not_contain: :"!~",
    istart_with: :"^*",
    iend_with: :"$*",
    icontain: :"~*",
    not_istart_with: :"!^*",
    not_iend_with: :"!$*",
    not_icontain: :"!~*",

    include: :"|=",
    not_include: :"!|=",
    any_gt: :"|>",
    any_gteq: :"|>=",
    any_lt: :"|<",
    any_lteq: :"|<=",
    all_gt: :"&>",
    all_gteq: :"&>=",
    all_lt: :"&<",
    all_lteq: :"&<=",

    size_eq: :"#=",
    size_not_eq: :"#!=",
    size_gt: :"#>",
    size_gteq: :"#>=",
    size_lt: :"#<",
    size_lteq: :"#<=",

    any_start_with: :"|^",
    all_start_with: :"&^",
  }.freeze
end
