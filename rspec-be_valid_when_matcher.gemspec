Gem::Specification.new do |s|
  s.name             = 'rspec-be_valid_when_matcher'
  s.version          = '0.3.0'

  s.author           = 'Marek Tuchowski'
  s.email            = 'marek@tuchowski.com.pl'
  s.homepage         = 'https://github.com/mtuchowski/rspec-be_valid_when_matcher'

  s.license          = 'MIT'
  s.summary          = 'RSpec be_valid_when matcher for ActiveRecord models.'
  s.description      = 'RSpec matcher for testing ActiveRecord models with a fluent language.'

  s.rdoc_options     = ['--charset', 'UTF-8']
  s.extra_rdoc_files = %w(README.md LICENSE)

  # Manifest
  s.files            = Dir.glob('lib/**/*')
  s.test_files       = Dir.glob('{spec}/**/*')
  s.require_paths    = ['lib']

  s.add_dependency 'rspec', '~> 3'
  s.add_dependency 'activemodel', '~> 4'
end
