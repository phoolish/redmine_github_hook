class AddRepositoriesGithub < ActiveRecord::Migration
  def self.up
    add_column :repositories, :github_project, :boolean, :default => false, :null => false
  end
  def self.down
    remove_column :repositories, :github_project
  end
end