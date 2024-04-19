# frozen_string_literal: true

module TestMethods
  def random_string(size)
    charset = Array("A".."Z") + Array("a".."z")
    Array.new(size) { charset.sample }.join
  end
end
