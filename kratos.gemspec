# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'kratos/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Kratos::RUBY_VERSION}"
  s.authors = ['jaisonerick']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Kratos is a rails project generator that is ready for deployment with
capistrano. Based on thoughtbot's "suspenders".
  HERE

  s.email = 'jaisonreis@gmail.com'
  s.executables = ['kratos']
  s.extra_rdoc_files = %w(README.md)
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/jaisonerick/kratos'
  s.license = 'MIT'
  s.name = 'kratos'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = 'A rails project generator based on thoughtbot\'s suspenders.'
  s.version = Kratos::VERSION

  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', Kratos::RAILS_VERSION
end
