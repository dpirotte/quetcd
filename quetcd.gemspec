# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quetcd/version'

Gem::Specification.new do |spec|
  spec.name          = "quetcd"
  spec.version       = Quetcd::VERSION
  spec.authors       = ["Dave Pirotte"]
  spec.email         = ["dpirotte@gmail.com"]

  spec.summary       = %q{Simple message queue built on etcd 3.x}
  spec.homepage      = "http://github.com/dpirotte/quetcd"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "etcdv3", "~> 0.6"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
end
