require 'rubygems'
require 'mq'

Signal.trap('INT') { AMQP.stop{ EM.stop } }
Signal.trap('TERM'){ AMQP.stop{ EM.stop } }

AMQP.start do
  MQ.new.queue('pubsub').subscribe(:ack => true) do |head, msg|
    puts "got #{msg.inspect}"
    head.ack
  end
end