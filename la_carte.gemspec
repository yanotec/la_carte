# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "la_carte/version"

Gem::Specification.new do |spec|
  spec.name          = "la_carte"
  spec.version       = LaCarte::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Jonathan C. Calixto"]
  spec.email         = ["jonathanccalixto@gmail.com"]

  spec.summary       = "LaCarte is a tool that simplifies the generation of menus."
  spec.description   = "LaCarte was thought to be simple and objective. It is" \
                       " a modularized tool, where you can specify which" \
                       " modules can be added to it. With LaCarte it is" \
                       " possible to generate dinamic Menus, Breadcrumps and" \
                       " Titles based on the content that is informed."
  spec.homepage      = "https://github.com/yanotec/la_carte"
  spec.licenses      = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
                         f.match(%r{^(test|spec|features)/})
                       end
  spec.require_paths = ["lib"]

  spec.add_dependency "i18n", "~> 0.7"
end
