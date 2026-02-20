require 'redmine'

# Tell Zeitwerk to ignore this plugin's lib directory
plugin_lib = File.join(File.dirname(__FILE__), 'lib')
Rails.autoloaders.each { |loader| loader.ignore(plugin_lib) }

# Require plugin files (patches self-apply when loaded)
require File.join(plugin_lib, 'redmine_git_remote/repositories_helper_patch')

# Register GitRemote SCM type
Redmine::Scm::Base.add "GitRemote"

Redmine::Plugin.register :redmine_git_remote do
  name 'Redmine Git Remote'
  author 'Alex Dergachev'
  url 'https://github.com/dergachev/redmine_git_remote'
  description 'Automatically clone and fetch remote git repositories'
  version '6.0.0'

  settings :default => {
    'git_remote_repo_clone_path' => Pathname.new(__FILE__).join("../").realpath.to_s + "/repos",
  }, :partial => 'settings/git_remote_settings'
end
