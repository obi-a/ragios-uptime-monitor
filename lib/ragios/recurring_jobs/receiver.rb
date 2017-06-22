#receive jobs from clients
module Ragios
  module RecurringJobs
    class Receiver
      include Celluloid::ZMQ

      attr_reader :receiver, :link, :scheduler

      def initialize
        @link = "tcp://127.0.0.1:5677"
        @socket = zmq_dealer
        bind_link
        @scheduler = Ragios::RecurringJobScheduler.new
      end

      def run
        loop { async.handle_message(@socket.read_multipart) }
      end

      def handle_message(message)
        puts "got message: #{message}"
        #@supervisor = Ragios::RagiosJob.supervise as: :job
        #@supervisor[:job].async.init(message)
        #Ragios::RagiosJob.new(message).start
        #acording to the message,
        @scheduler.perform(message)
      end

      def terminate
        @scheduler.terminate
        @socket.close
        super
      end

    private

      def zmq_dealer
        Socket::Dealer.new
      end

      def bind_link
        @socket.bind(@link)
      rescue IOError
        @socket.close
        raise
      end
    end
  end
end
