# frozen_string_literal: true

module Diffend
  # Modules grouping supported bundler commands
  module Commands
    # Bundler install command
    INSTALL = 'install'
    # Bundler update command
    UPDATE = 'update'
    # Bundler exec command
    EXEC = 'exec'
    # Bundler secure command introduced by diffend plugin
    SECURE = 'secure'
    # Bundler add command
    ADD = 'add'
  end
end
