require "spec_helper"

describe Quetcd::Queue do
  before(:each) do
    conn = Etcdv3.new(url: "http://localhost:2379")
    conn.del("\0", range_end: "\0")
  end

  let :queue do
    Quetcd::Queue.new
  end

  describe "#pop" do
    it "is nil with no messages" do
      queue.pop.must_be_nil
    end

    it "pops the oldest message off of the queue" do
      queue.push("foo")
      queue.push("bar")
      queue.pop.must_equal("foo")
      queue.push("baz")
      queue.pop.must_equal("bar")
      queue.pop.must_equal("baz")
    end
  end

end
