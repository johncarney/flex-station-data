require "active_support/concern"

module FlexStationData
  module Concerns
    module Service
      extend ActiveSupport::Concern

      def to_proc
        Proc.new(&method(:call))
      end

      class_methods do
        def call(*args, &block)
          new(*args).call(&block)
        end

        def to_proc
          Proc.new(&method(:call))
        end
      end
    end
  end
end
