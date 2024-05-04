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
end
