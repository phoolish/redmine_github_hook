require_dependency 'repository'

# Patches Redmine's Repository dynamically.
module RepositoryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development      
    end

  end
  
  module ClassMethods
    
  end
  
  module InstanceMethods
    # Get the remote url from the repoisotory.
    def remote_url
      if Setting.plugin_redmine_github_hook[:enabled] and self.type == 'Git' and !self.nil?
        result = Git.new.get_remote_url(self)
        if result and result.is_a?(Array) and result.length == 2
          remote_name = result[0].split("\t")[0].strip
          remote_url = result[0].split("\t")[1]
          if remote_name == 'origin'
            result[0].split("\t")[1].split(' ')[0]
          end
        end
      end
    end
  end    
end

# Add module to Repository
Respository.send(:include, RepositoryPatch)