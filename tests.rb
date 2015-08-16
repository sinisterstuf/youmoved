require 'test/unit'
require_relative 'app'

# stub logger.info
def logger
    Logger.new(STDERR)
end

class TestDistanceCalculator < Test::Unit::TestCase
    def test_determining_movement_scale
        assert_match(/^[0-9.]+ km$/, calculate_distance('1;1', '2;2'))
        assert_match(/^[0-9]+ m$/, calculate_distance('1;1', '1.01;1.01'))
        assert_equal("you've barely moved!", calculate_distance('1;1', '1.00001;1.00001'))
    end

    def test_significant_figures
        assert_equal(2010.to_s + ' km', calculate_distance('1;1', '30;3'))
        assert_equal(196.to_s + ' km', calculate_distance('1;1', '3;3'))
        assert_equal(97.8.to_s + ' km', calculate_distance('1;1', '2;2'))
        assert_equal(9.78.to_s + ' km', calculate_distance('1;1', '1.1;1.1'))
        assert_equal(978.to_s + ' m', calculate_distance('1;1', '1.01;1.01'))
        assert_equal(97.to_s + ' m', calculate_distance('1;1', '1.001;1.001'))
        assert_equal(9.to_s + ' m', calculate_distance('1;1', '1.0001;1.0001'))
    end
end
