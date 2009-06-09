# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "em-spec/rspec"

describe MessageQueue do
  include EM::SpecHelper
  #include EM::Spec
  
  it "should load connect settings from yaml file" do
    MessageQueue.connect_params.should be_an_instance_of Hash
  end

  describe "Using AMQP" do
    it "should connect with default config settings" do
      MessageQueue.expects(:connect_params).returns(@settings = mock)
      AMQP.expects(:connect).with(@settings)
      MessageQueue.connect
    end
    
    it "should start with passed connect settings" do
      settings = MessageQueue.connect_params
      AMQP.expects(:start).with(settings)
      MessageQueue.start(settings)
    end
  
    it "should connect and run block if block passed" do
      AMQP.expects(:start).yields
      MessageQueue.start { puts "hi" }
    end
    
    
    it "should return backup jobs queue" do
      em do
        q = MessageQueue.pending_backup_jobs_queue
        q.should be_an_instance_of MQ::Queue
        q.name.should == MessageQueue::Backup::PendingJobsQueue
        done
      end
    end
    
    it "should return backup worker topic exchange" do
      em do
        ex = MessageQueue.backup_worker_topic
        ex.name.should == MessageQueue::Backup::WorkerExchange
        ex.type.should == :topic
        done
      end
    end
    
    it "should return backup worker topic exchange subscription queue" do
      @site = 'test'
      em do 
        q = MessageQueue.backup_worker_subscriber_queue(@site)
        q.should be_an_instance_of MQ::Queue
        q.name.should == MessageQueue::Backup::WorkerTopicQueue
        done
      end
    end
    
    describe "connected to server" do
      it "should connect" do
        em do
          lambda {
            # doesn't seem to 
            MessageQueue.start { done }
          }.should_not raise_error
          done
        end
      end
      
      # Haven't found a way to test real connect to our server inside specs...
      describe "topic exchange" do
        it "subscriber queue should receive messages published" do
        end
      end
    end
  end
end
