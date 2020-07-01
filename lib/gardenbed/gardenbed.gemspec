# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gardenbed/version'

Gem::Specification.new do |spec|
  spec.name          = 'gardenbed'
  spec.version       = Gardenbed::VERSION
  spec.authors       = ['Christopher Guess']
  spec.email         = ['cguess@gmail.com']

  spec.summary       = %q{A gem to manage windows when creating a TUI.}
  spec.description   = %q{A gem to manage windows when creating a TUI.}
  spec.homepage      = 'http://www.example.com'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'http://mygemserver.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'http://www.example.com'
  spec.metadata['changelog_uri'] = 'http://www.example.com'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'curses'
  spec.add_dependency 'hashdiff'
  spec.add_dependency 'logger'
  spec.add_dependency 'eventmachine'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rubocop'
end
