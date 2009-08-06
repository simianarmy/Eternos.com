# $Id$

#require File.dirname(__FILE__) + '/../spec_helper'
require 'rubygems'
require 'mq'

Signal.trap('INT') { AMQP.stop{ EM.stop } }
Signal.trap('TERM'){ AMQP.stop{ EM.stop } }

describe "BackupEmailsUploader" do
  it "should send to subscriber as soon as it is published" do
    #AMQP.start(MessageQueue.connect_params) do
    AMQP.start do
        10.times do |count|
          puts "step #{count}"
          id = rand(10)
          puts "Publishing id = #{id}"
          #MQ.queue('EmailUploadQueue').bind(MQ.direct('backup_processing', :durable => true)).publish({:id => id}.to_json)
          MQ.new.queue('pubsub').publish(id)
          sleep(1)
        end
        puts "Finished loop, waiting for stop"
      end
  end
end