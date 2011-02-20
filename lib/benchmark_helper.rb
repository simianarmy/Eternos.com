# $Id$

require 'benchmark'

module BenchmarkHelper
  class << self
    def rails_log(name)
      result = nil
      mark = Benchmark.realtime { result = yield }
      RAILS_DEFAULT_LOGGER.info "#{name} executed in #{mark} seconds"
      result
    end
  end
end
