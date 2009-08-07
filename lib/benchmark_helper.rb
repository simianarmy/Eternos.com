# $Id$

require 'benchmark'

module BenchmarkHelper
  class << self
    def rails_log(name)
      mark = Benchmark.realtime { yield }
      RAILS_DEFAULT_LOGGER.info "#{name} executed in #{mark} seconds"
    end
  end
end
