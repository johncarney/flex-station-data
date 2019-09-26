module FlexStationData
  module Concerns
    module Callable
      class << self
        def [](verb)
          @@__callable_modules[verb] ||= Module.new.tap { |mod| __make_callable(mod, verb) }
        end

        private

        def __make_callable(mod, verb)
          class_methods = Module.new do
            define_method verb do |*args, &block|
              new(*args).send(verb, &block)
            end

            define_method :to_proc do
              Proc.new(&method(verb))
            end
          end

          mod.singleton_class.define_method :included do |base|
            base.extend class_methods
          end
        end
      end

      __make_callable(self, :call)

      @@__callable_modules = { call: self }
    end
  end
end
