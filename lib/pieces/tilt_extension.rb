require 'tilt'

module Tilt
  if respond_to?(:register_lazy)
    register_lazy :MustacheTemplate, 'pieces/tilt/mustache', 'mustache', 'ms'
    register_lazy :CssTemplate, 'pieces/tilt/css', 'css'
  else # support tilt v1
    require 'pieces/tilt/mustache'
    register Tilt::MustacheTemplate, 'mustache', 'ms'

    require 'pieces/tilt/css'
    register Tilt::CssTemplate, 'css'
  end
end
