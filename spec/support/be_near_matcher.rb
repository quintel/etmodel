module CustomMatchers
  ##
  # The be_near matcher is a shortcut for be_close(.., 0.01)
  #
  class BeNear
    def initialize(expected)
      @expected = expected
    end

    def matches?(actual)
      @actual = actual
      (@actual - @expected).abs < 0.01
    end

    def failure_message_for_should
      "expected #{@actual.inspect} to be near #{@expected.inspect}"
    end

    def failure_message_for_should_not
      "expected #{@actual.inspect} not to to be near #{@expected.inspect}"
    end
  end

  def be_near(expected)
    BeNear.new(expected)
  end
end
