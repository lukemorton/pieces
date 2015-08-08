require 'tilt'

module Tilt
  if respond_to?(:register_lazy)
    register_lazy 'Pieces::Tilt::MustacheTemplate', 'pieces/tilt/mustache', 'mustache', 'ms'
    register_lazy 'Pieces::Tilt::CssTemplate', 'pieces/tilt/css', 'css'
  else # support tilt v1
    require 'pieces/tilt/mustache'
    register Pieces::Tilt::MustacheTemplate, 'mustache', 'ms'

    require 'pieces/tilt/css'
    register Pieces::Tilt::CssTemplate, 'css'
  end
end
