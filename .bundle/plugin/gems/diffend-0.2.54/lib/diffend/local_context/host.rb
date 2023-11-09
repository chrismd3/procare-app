# frozen_string_literal: true

require 'etc'

module Diffend
  # Module responsible for building local context
  module LocalContext
    # Module responsible for building host information from local context
    module Host
      # Regexp that checks if we're running under Windows
      WINDOWS_REGEXP = /cygwin|mswin|mingw|bccwin|wince|emx/

      private_constant :WINDOWS_REGEXP

      class << self
        # Build host information
        #
        # @return [Hash]
        def call
          uname = Etc.uname

          {
            'command' => command,
            'name' => uname[:nodename],
            'system' => {
              'machine' => uname[:machine],
              'name' => uname[:sysname],
              'release' => uname[:release],
              'version' => uname[:version]
            },
            'tags' => tags,
            'user' => Etc.getpwuid(Process.uid)&.name || ENV['USERNAME'],
            'pid' => Process.pid
          }.freeze
        end

        private

        # Build host command information
        #
        # @return [Hash]
        def command
          if File.exist?($PROGRAM_NAME)
            if defined?(JRUBY_VERSION) || WINDOWS_REGEXP =~ RUBY_PLATFORM
              name = $PROGRAM_NAME.split('/').last.strip
              command = "#{name} #{ARGV.join(' ')}"
            else
              array = `ps -p #{Process.pid} -o command=`.strip.split(' ')
              array.shift if array.first.end_with?('bin/ruby')
              name = array.shift.split('/').last.strip
              command = "#{name} #{array.join(' ')}"
            end

            { 'name' => clean(command), 'title' => '' }
          else
            { 'name' => clean(ARGV.join(' ')), 'title' => clean($PROGRAM_NAME) }
          end
        end

        # Build host tags
        #
        # @return [Array]
        def tags
          tags = prepare_user_tags

          if ENV.key?('GITHUB_ACTIONS')
            tags << 'ci'
            tags << 'ci-github'
          end

          if ENV.key?('CIRCLECI')
            tags << 'ci'
            tags << 'ci-circle'
          end

          tags
        end

        # Prepare user tags
        #
        # @return [Array]
        def prepare_user_tags
          if ENV.key?('DIFFEND_TAGS')
            ENV['DIFFEND_TAGS'].split(',')
          else
            []
          end
        end

        # @param str [String] that we want to clean and truncate
        def clean(str)
          str
            .dup
            .gsub(/[[:space:]]+/, ' ')
            .strip[0...255]
        end
      end
    end
  end
end
