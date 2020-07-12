# frozen_string_literal: true

module FlexStationData
  module Concerns
    module Callable
      class << self
        def included(base)
          base.include with(:call)
        end

        def with(verb)
          callable_modules[verb.to_sym] ||= Module.new do
            define_singleton_method(:included) do |base|
              base.define_singleton_method(verb) do |*args|
                new(*args).public_send(verb)
              end

              base.define_singleton_method(:to_proc) do
                method(verb).to_proc
              end
            end
          end
        end

        alias [] with

        def callable_modules
          @callable_modules ||= {}
        end
      end
    end
  end
end
