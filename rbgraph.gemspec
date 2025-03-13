Gem::Specification.new do |s|
  s.name        = 'rbgraph'
  s.version     = '0.6.0'
  s.date        = '2025-03-14'
  s.summary     = 'Ruby graphs!'
  s.description = 'Simple generic graphs and operations on them in Ruby!'
  s.authors     = ['George Lamprianidis']
  s.email       = 'giorgos.lamprianidis@gmail.com'
  s.files       = Dir["lib/**/*"] + ["Gemfile", "README.md"]
  s.homepage    = 'https://github.com/glampr/rbgraph'
  s.license     = 'MIT'

  s.add_runtime_dependency 'json', '~> 2.1'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
end
