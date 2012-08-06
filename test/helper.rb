require 'minitest/autorun'

class NeoRailsCase < MiniTest::Spec
  class << self
    alias :context :describe
    alias :test :it
  end
end
