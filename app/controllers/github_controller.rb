require 'github_api'

class GithubController < ApplicationController
  unloadable

  layout 'base'
  
  before_filter :find_project, :only => :edit
  
  @github = Github.new(
    :client_id => Setting.plugin_redmine_github_hook[:github_id],
    :client_secret => Setting.plugin_redmine_github_hook[:github_secret]
  )
  
  # Reroute to github for application verifcation.
  def register
    @github.authorize_url :redirect_uri => url_for(:action => 'registered', :only_path => false, :protocol => 'https'), 
      :scope => 'repo'
  end
  
  # Returned code from GitHub for token authentication.
  def registered
    Settings.plugin_redmine_github_hook[:github_token] = @github.get_token( params[:code],  )
    render(:text => l(:github_authorize_success,
      :link => link_to(l(:github_authorize_success_link), {
        :controller => 'settings', :model => 'plugin', :id => 'redmine_github_hook'
        })))
  end
  
  def edit
    github_token = Setting.plugin_redmine_github_hook[:github_token]
    unless github_token.blank?
      @repository = @project.repository
      if !@repository
        @repository = Repository.factory('Git')
        @repository.project = @project if @repository
      end
      if request.post? && @repository
        @github_repos = Github::Repos.new :oauth_token => github_token
        response = @github_repos.get_repo :user_name => params[:user], :repo_name => params[:repo]
        if response.status != "200" #TODO A better check then just that it wasn't a success.
          repo = {
            :name => params[:repo],
            :description => (@project.description) ? @project.description : "",
            :public => params[:public],
            :has_issues => params[:issues],
            :has_wiki => params[:wiki],
            :has_downloads => params[:downloads]
          }
          repo[:org] = params[:user] if params[:org]
          new_repo = @github_repos.create_repo(repo) #TODO Error check
          if new_repo
            # Create github hook
            success = @github_repos.create_hook params[:user], params[:repo],
              :name => 'web',
              :active => true,
              :config => {
                :url => url_for(:action => 'index', :controller => 'github_hook', :only_path => false) + "?project_id="+@project.identifier
              }
            @repository.attributes = {
              :type => 'Git',
              :github_project => true,
              :url => new_repo.ssh_url,
              :path_encoding => "UTF-8" #TODO deal with encoding rather then setting default.
            }
            @repository.save
            
          end
        end
      end
    end
  end
end