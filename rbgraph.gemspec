Gem::Specification.new do |s|
  s.name        = 'rbgraph'
  s.version     = '0.0.1'
  s.date        = '2014-12-03'
  s.summary     = 'Generic Ruby graphs and operations on them!'
  s.description = 'Generic Ruby graphs and operations on them!'
  s.authors     = ['George Lamprianidis']
  s.email       = 'giorgos.lamprianidis@gmail.com'
  s.files       = Dir["lib/**/*"] + ["Gemfile", "README.md"]
  s.homepage    = 'http://rubygems.org/gems/rbgraph'
  s.license     = 'MIT'

  s.add_development_dependency "rspec"
end
