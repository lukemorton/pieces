module Pieces
  module Tilt
    class MustacheTemplate < Template
      def initialize_engine; end

      def prepare; end

      def evaluate(scope, locals, &block)
        require 'mustache'
        Mustache.render(data, with_block(view_model(scope, locals), &block))
      end

      private

      def view_model(scope, locals)
        if scope.is_a?(Hash)
          locals.merge(scope)
        elsif scope.respond_to?(:to_h)
          locals.merge(scope.to_h)
        else
          locals
        end
      end

      def with_block(view_model, &block)
        view_model.merge(:yield => block.nil? ? '' : block.call)
      end
    end
  end
end
