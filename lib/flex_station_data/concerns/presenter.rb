require "active_support/concern"

module FlexStationData
  module Concerns
    module Presenter
      extend ActiveSupport::Concern

      def to_proc
        Proc.new(&method(:present))
      end

      class_methods do
        def present(*args, &block)
          new(*args).present(&block)
        end

        def to_proc
          Proc.new(&method(:present))
        end
      end
    end
  end
end
