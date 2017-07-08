module Ragios
  module Events
    class Publisher < Ragios::ZMQ

      def initialize
        @link = "tcp://127.0.0.1:5555"
        @socket = zmq_publisher
        connect_link
      end
    end
  end
end
