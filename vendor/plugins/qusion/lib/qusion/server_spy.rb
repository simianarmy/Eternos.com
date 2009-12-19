# encoding: UTF-8

module Qusion
  module ServerSpy
    extend self
    def server_type
      if defined?(DaemonKit::Initializer)
        :none
      elsif defined?(Mongrel) && defined?(Mongrel::MongrelProtocol)
        :evented
      elsif defined?(Mongrel)
        :standard
      elsif defined?(SCGI)
        :standard
      elsif defined?(WEBrick)
        :standard
      elsif defined?(PhusionPassenger)
        :passenger
      elsif defined?(Thin)
        :evented
      else
        :none
      end
    end
  end
end
