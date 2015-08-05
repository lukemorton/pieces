require 'tilt'

module Tilt
  register_lazy :MustacheTemplate, 'tilt/mustache', 'mustache', 'ms'
  register_lazy :CssTemplate, 'tilt/css', 'css'
end
