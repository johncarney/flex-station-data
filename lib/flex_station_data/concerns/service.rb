require "active_support/concern"

module FlexStationData
  module Concerns
    module Service
      extend ActiveSupport::Concern

      class_methods do
        def call(*args, &block)
          new(*args).call(&block)
        end
      end
    end
  end
end
