require 'tilt'

module Tilt
  if respond_to?(:register_lazy)
    register_lazy 'Pieces::Tilt::MustacheTemplate', 'pieces/tilt/mustache', 'mustache', 'ms'
  else # support tilt v1
    require 'pieces/tilt/mustache'
    register Pieces::Tilt::MustacheTemplate, 'mustache', 'ms'
  end
end
