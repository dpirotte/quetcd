require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'quetcd'

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/spec'
require 'net/http'
require 'timeout'

Minitest::Reporters.use!

def etcd_running?
  Net::HTTP.get(URI("http://localhost:2379/health")) == '{"health": "true"}'
end

def wait_for_etcd(timeout = 2)
  Timeout.timeout(timeout) do
    while true do
      return if etcd_running? rescue nil
    end
  end
end

def start_etcd
  system("docker-compose up --force-recreate --remove-orphans -d etcd")
end

def stop_etcd
  system("docker-compose rm -f -s -v etcd")
end

if ENV["MANAGE_ETCD"]
  start_etcd
  wait_for_etcd
end
