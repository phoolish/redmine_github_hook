# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'VERSION.rb')

Gem::Specification.new do |s|
  s.name        = 'redmine_github_hook'
  s.version     = VERSION
  s.authors     = ['Jakob Skjerning', ' Riceball LEE']
  s.email       = ['test@test.com']
  
  s.summary     = 'Redmine Github Hook plugin'
  s.description = 'This plugin allows your Redmine support Github and install to receive Github post-receive notifications\n And show the scm url in the repository page'

  s.rubyforge_project = "redmine_github_hook" #TODO

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
end

