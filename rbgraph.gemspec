Gem::Specification.new do |s|
  s.name        = 'rbgraph'
  s.version     = '0.0.8'
  s.date        = '2014-12-03'
  s.summary     = 'Ruby graphs!'
  s.description = 'Simple generic graphs and operations on them in Ruby!'
  s.authors     = ['George Lamprianidis']
  s.email       = 'giorgos.lamprianidis@gmail.com'
  s.files       = Dir["lib/**/*"] + ["Gemfile", "README.md"]
  s.homepage    = 'https://github.com/glampr/rbgraph'
  s.license     = 'MIT'

  s.add_development_dependency "rspec"
end
