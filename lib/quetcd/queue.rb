class Quetcd::Queue
  def initialize(url: "http://localhost:2379", name: "quetcd")
    @conn = Etcdv3.new(url: url)
    @name = "quetcd/#{name}/"
    @range_end = "quetcd/#{name}0"
  end

  def enqueue(message)
    key = "#{@name}#{Time.now.to_f.to_s.tr(".","")}"
    @conn.put(key, message)
  end

  def dequeue
    kvs = @conn.get(@name, range_end: @range_end, limit: 5, sort_order: :ascend, sort_target: :create).kvs

    first_unclaimed_kv = kvs.detect do |kv|
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

    first_unclaimed_kv ? first_unclaimed_kv.value : nil
  end
end
