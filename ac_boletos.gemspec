# encoding: utf-8
Gem::Specification.new do |s|
  s.name = %q{ac_boletos}
  s.version = "0.3.2"
  s.date = %q{2011-10-16}
  s.authors = ["Ricardo Acras", "Egon Hilgenstieler"]
  s.email = %q{ricardo@acras.com.br egon@acras.com.br}
  s.summary = %q{ACBoletos permite a emissão de boletos :).}
  s.homepage = %q{http://www.acras.com.br/}
  s.description = %q{ACBoletos permite a emissão de boletos :)}
  s.add_dependency('barcodecalc', '>= 0.0.2')
  s.files = Dir['*'] + Dir['app/**/*'] + Dir['assets/**/*'] + Dir['migrations/*.rb'] + Dir['tasks/*'] +
            Dir['rails/**/*.rb']+Dir['test/**/*.rb']+Dir['lib/**/*']+Dir['config/**/*']
end
