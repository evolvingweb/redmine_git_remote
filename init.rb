require 'redmine'

# Register the GitRemote SCM type (adapter is inherited from Repository::Git).
Redmine::Scm::Base.add "GitRemote"

Redmine::Plugin.register :redmine_git_remote do
  name 'Redmine Git Remote'
  author 'Alex Dergachev'
  url 'https://github.com/dergachev/redmine_git_remote'
  description 'Automatically clone and fetch remote git repositories'
  version '7.0.0'
  requires_redmine version_or_higher: '7.0.0'

  settings :default => {
    'git_remote_repo_clone_path' => Pathname.new(__FILE__).join("../").realpath.to_s + "/repos",
  }, :partial => 'settings/git_remote_settings'
end

# Redmine 7 loads this init.rb from INSIDE its own `to_prepare` block and
# eager-loads the plugin lib/ + app/ via Zeitwerk. So `RepositoriesHelper` and our
# patch module both autoload here — apply the patch DIRECTLY (the module no longer
# self-applies). `Repository::GitRemote` (app/models) and
# `RedmineGitRemote::PoorMansCapture3` (lib) autoload when referenced. refs #108530.
unless RepositoriesHelper.included_modules.include?(RedmineGitRemote::RepositoriesHelperPatch)
  RepositoriesHelper.include(RedmineGitRemote::RepositoriesHelperPatch)
end
