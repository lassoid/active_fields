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
    eq: %w[= eq],
    not_eq: %w[!= not_eq],
    gt: %w[> gt],
    gteq: %w[>= gteq gte],
    lt: %w[< lt],
    lteq: %w[<= lteq lte],
    start_with: %w[^ start_with],
    end_with: %w[$ end_with],
    contain: %w[~ contain],
    not_start_with: %w[!^ not_start_with],
    not_end_with: %w[!$ not_end_with],
    not_contain: %w[!~ not_contain],
    istart_with: %w[^* istart_with],
    iend_with: %w[$* iend_with],
    icontain: %w[~* icontain],
    not_istart_with: %w[!^* not_istart_with],
    not_iend_with: %w[!$* not_iend_with],
    not_icontain: %w[!~* not_icontain],
    include: %w[|= include],
    not_include: %w[!|= not_include],
    any_gt: %w[|> any_gt],
    any_gteq: %w[|>= any_gteq any_gte],
    any_lt: %w[|< any_lt],
    any_lteq: %w[|<= any_lteq any_lte],
    all_gt: %w[&> all_gt],
    all_gteq: %w[&>= all_gteq all_gte],
    all_lt: %w[&< all_lt],
    all_lteq: %w[&<= all_lteq all_lte],
  }.freeze
end
