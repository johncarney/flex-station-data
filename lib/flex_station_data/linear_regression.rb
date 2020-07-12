# frozen_string_literal: true

require "active_support/core_ext"
require "linefit"

module FlexStationData
  class LinearRegression
    attr_reader :x, :y, :min_r_squared

    def initialize(x, y, min_r_squared: 0.0, **)
      @x = x
      @y = y
      @min_r_squared = min_r_squared.to_f
    end

    def slope
      coefficients[1]
    end

    def intercept
      coefficients[0]
    end

    def r_squared
      @r_squared ||= line_fit.rSquared
    rescue TypeError
      nil
    end

    def quality
      "poor fit" if r_squared.present? && r_squared < min_r_squared
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
