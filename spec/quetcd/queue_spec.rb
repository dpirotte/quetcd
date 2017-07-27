require "spec_helper"

describe Quetcd::Queue do
  before(:each) do
    conn = Etcdv3.new(url: "http://localhost:2379")
    conn.del("\0", range_end: "\0")
  end

  let :queue do
    Quetcd::Queue.new
  end

  describe "#dequeue" do
    it "is nil with no messages" do
      queue.dequeue.must_be_nil
    end

    it "pops the oldest message off of the queue" do
      queue.enqueue("foo")
      queue.enqueue("bar")
      queue.dequeue.must_equal("foo")
      queue.enqueue("baz")
      queue.dequeue.must_equal("bar")
      queue.dequeue.must_equal("baz")
    end
  end
end
