class Etcdq::Queue
  def initialize(url: "http://localhost:2379", name: "etcdq")
    @conn = Etcdv3.new(url: url)
    @name = "etcdq/#{name}/"
    @range_end = "etcdq/#{name}0"
  end

  def push(message)
    key = "#{@name}#{Time.now.to_f.to_s.tr(".","")}"
    @conn.put(key, message)
  end

  def pop
    kvs = @conn.get(@name, range_end: @range_end, limit: 5, sort_order: :ascend, sort_target: :create).kvs

    kv = kvs.detect do |kv|
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

    kv ? kv.value : nil
  end
end
