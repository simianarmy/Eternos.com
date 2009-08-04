require 'workling/clients/base'
Workling.try_load_an_amqp_client

#
#  An Ampq client
#
module Workling
  module Clients
    class AmqpClient < Workling::Clients::Base
      
      # starts the client. 
      def connect
        begin
          @amq = MQ.new
        rescue
          raise WorklingError.new("couldn't start amq client. if you're running this in a server environment, then make sure the server is evented (ie use thin or evented mongrel, not normal mongrel.)")
        end
      end
      
      # no need for explicit closing. when the event loop
      # terminates, the connection is closed anyway. 
      def close; true; end
      
      # subscribe to a queue
      def subscribe(key)
        puts "Subscribing to queue: #{key}"
        puts "with amqp settings: #{AMQP.settings.inspect}"
        @amq.queue(key).subscribe do |data|
          value = Marshal.load(data)
          yield value
        end
      end
      
      # request and retrieve work
      def retrieve(key); @amq.queue(key); end
      def request(key, value)
        puts "Publishing to queue #{key}: #{value.inspect}"
        puts "with amqp settings: #{AMQP.settings.inspect}"
        data = Marshal.dump(value)
        @amq.queue(key).publish(data)
      end
    end
  end
end
