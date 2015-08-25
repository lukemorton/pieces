require 'pieces/config'
require 'pieces/configurable'
require 'pieces/app'
require 'pieces/route_compiler'
require 'pieces/tilt_extension'
require 'pieces/server'
require 'pieces/builder'
require 'pieces/generator'
require 'pieces/publisher'
require 'pieces/rails' if defined?(Rails)
require 'pieces/version'

%w(bits-n-pieces bourbon neat bitters compass sass uglifier).each do |gem|
  begin require gem; rescue LoadError; end
end

module Pieces
end
