require 'test/unit'
require_relative 'app'

# stub logger.info
def logger
    Logger.new(STDERR)
end

class TestYouMoved < Test::Unit::TestCase
    def test_distance_calculator

        # determining scale of movement
        assert_match(/^[0-9.]+ km$/, calculate_distance('1;1', '2;2'))
        assert_match(/^[0-9]+ m$/, calculate_distance('1;1', '1.01;1.01'))
        assert_equal("you've barely moved!", calculate_distance('1;1', '1.00001;1.00001'))

    end
end
