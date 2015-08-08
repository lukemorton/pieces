require 'tilt'

module Tilt
  if respond_to?(:register_lazy)
    register_lazy :MustacheTemplate, 'tilt/mustache', 'mustache', 'ms'
    register_lazy :CssTemplate, 'tilt/css', 'css'
  elsif defined?(Rails)
    # Register these yourself
  else # support tilt v1
    require 'tilt/mustache'
    register MustacheTemplate, 'mustache', 'ms'

    require 'tilt/css'
    register CssTemplate, 'css'
  end
end
