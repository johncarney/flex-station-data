require "active_support/core_ext"
require "linefit"

module FlexStationData
  class LinearRegression
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def slope
      coefficients[0]
    end

    def intercept
      coefficients[1]
    end

    def r_squared
      @r_squared ||= line_fit.rSquared
    rescue TypeError
      nil
    end

    private

    def coefficients
      @coefficients ||= line_fit.coefficients
    rescue TypeError
      [ nil, nil ]
    end

    def line_fit
      @line_fit ||= LineFit.new.tap { |lf| lf.setData(x, y) }
    end
  end
end
