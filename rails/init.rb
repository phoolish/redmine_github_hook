require 'dispatcher'
require 'redmine'

require File.dirname(__FILE__) + '/lib/repository_patch.rb'
require File.dirname(__FILE__) + '/lib/github_repositories_patch.rb'
require File.dirname(__FILE__) + '/lib/git.rb'

Redmine::Plugin.register :redmine_github_hook do
  name 'Redmine Github Hook plugin'
  author 'Jakob Skjerning, Riceball LEE'
  description 'This plugin allows your Redmine support Github and install to receive Github post-receive notifications\n And show the scm url in the repository page'
  version '0.2.0'

    settings(:default => {
             :enabled  => false,
             :git_dir  => '',
             :github_id => '',
             :github_secret => '',
             :github_token => ''
             },
             :partial => 'settings/github_hook_setting')

end

ActiveRecord::Base.observers << :repository_observer
