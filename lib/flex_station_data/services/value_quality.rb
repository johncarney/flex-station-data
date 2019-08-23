require "singleton"
require "active_support/core_ext"

module FlexStationData
  class ValueQuality
    include Concerns::Service

    class Good
      include Singleton

      def good?
        true
      end

      def to_s
        "good"
      end
    end

    class Bad
      attr_reader :description

      def initialize(description)
        @description ||= description
      end

      def good?
        false
      end

      def to_s
        description
      end
    end

    attr_reader :value, :threshold

    def initialize(value, threshold: nil)
      @value = value
      @threshold = threshold
    end

    def no_data?
      value.blank?
    end

    def saturated?
      value == "#SAT"
    end

    def invalid?
      !(no_data? || saturated? || value.is_a?(Numeric))
    end

    def below_threshold?
      threshold.present? && value.is_a?(Numeric) && value < threshold
    end

    def call
      if no_data?
        Bad.new("No data")
      elsif saturated?
        Bad.new("Saturated")
      elsif invalid?
        Bad.new("Invalid data")
      elsif below_threshold?
        Bad.new("Below threshold")
      else
        Good.instance
      end
    end
  end
end
