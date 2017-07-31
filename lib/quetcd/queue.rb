class Quetcd::Queue
  def initialize(url: "http://localhost:2379", name: "quetcd")
    @conn = Etcdv3.new(url: url)
    @name = "quetcd/#{name}/"
    @range_end = "quetcd/#{name}0"
  end

  def enqueue(message, priority: 5)
    ts = Time.now.to_f.to_s.tr(".","")
    key = "#{@name}#{priority}/#{ts}"
    @conn.put(key, message)
  end

  def dequeue
    candidate_messages = pending_messages(limit: 10)

    dequeued_message = candidate_messages.detect do |kv|
      @conn.transaction do |txn|
        txn.compare = [
          txn.mod_revision(kv.key, :equal, kv.mod_revision)
        ]
        txn.success = [
          # txn.del(kv.key) <= does not work for some reason
          Etcdserverpb::DeleteRangeRequest.new(key: kv.key)
        ]
      end.succeeded
    end

    dequeued_message ? dequeued_message.value : nil
  end

  def peek
    first_pending_message = pending_messages(limit: 1).first
    first_pending_message ? first_pending_message.value : nil
  end

  private
  def pending_messages(limit: 5)
    @conn.get(@name, range_end: @range_end, limit: limit, sort_order: :ascend, sort_target: :key).kvs
  end
end
