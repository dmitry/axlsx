module Axlsx
  # version
  # When using bunle exec rake and referencing the gem on github or locally
  # it will use the gemspec, which preloads this constant for the gem's version.
  # We check to make sure that it has not already been loaded
  VERSION="1.0.15" unless Axlsx.const_defined? :VERSION
end
