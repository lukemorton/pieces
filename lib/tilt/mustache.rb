require 'mustache'

module Tilt
  class MustacheTemplate < Template
    def initialize_engine; end

    def prepare; end

    def evaluate(scope, locals, &block)
      Mustache.render(data, locals.merge(scope.is_a?(Hash) ? scope : {}).merge(:yield => block.nil? ? '' : block.call))
    end
  end
end
