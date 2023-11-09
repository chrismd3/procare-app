# frozen_string_literal: true

module Diffend
  # Repository for integrations
  class IntegrationRepository
    # Plugin code entry in Gemfile
    GEMFILE_PLUGIN_ENTRY = 'plugin \'diffend\''
    # Gemfile file name
    GEMFILE_FILE_NAME = 'Gemfile'
    # Gemfile backup file name
    GEMFILE_BACKUP_FILE_NAME = 'Gemfile.backup'
    # Plugin install command
    PLUGIN_INSTALL_COMMAND = [
      'bundle',
      "_#{Bundler::VERSION}_",
      'plugin',
      'install',
      'diffend',
      '--source https://rubygems.org'
    ].join(' ').freeze

    attr_reader :command, :name, :repository

    # @param command [String] command executed via bundler
    # @param name [String] repository name
    def initialize(command, name)
      @command = command
      @name = name
      @repository = Diffend::Repository.new(command, name)
    end

    # @return [String] full name of the repository with command
    def full_name
      "#{command}_#{name}"
    end

    # @param path [String] path to the repository
    def config?(path)
      # check if .diffend.yml exists
      return if File.exist?(File.join(path, Diffend::Config::FILENAME))

      puts "Diffend configuration does not exist for #{command} #{name}"
      exit 1
    end

    # @param path [String] path to the repository
    def install_plugin(path)
      cmd = Diffend::Shell.call_in_path(path, PLUGIN_INSTALL_COMMAND)

      unless cmd[:exit_code].zero?
        puts "#{PLUGIN_INSTALL_COMMAND} failed"
        puts cmd[:stderr]
        exit 1
      end

      switch_plugin_to_development(path, cmd[:stdout])
      add_plugin_to_gemfile(path)
    end

    private

    # @param path [String] path to the repository
    # @param stdout [String] stdout from plugin install command
    def switch_plugin_to_development(path, stdout)
      installed_version = stdout.scan(/Installing diffend (\d*\.\d*\.\d*)/)[0][0]
      diffend_working_path = File.expand_path('..', Bundler.bin_path)
      bundler_plugins_path = File.join(path, '.bundle/plugin/gems')
      bundler_diffend_plugin_path = File.join(bundler_plugins_path, "diffend-#{installed_version}")
      FileUtils.mv(bundler_diffend_plugin_path, "#{bundler_diffend_plugin_path}-")
      FileUtils.ln_s(diffend_working_path, bundler_diffend_plugin_path)
    end

    # @param path [String] path to the repository
    def add_plugin_to_gemfile(path)
      gemfile_path = File.join(path, GEMFILE_FILE_NAME)

      FileUtils.mv(gemfile_path, File.join(path, GEMFILE_BACKUP_FILE_NAME))
      file = File.open(gemfile_path, 'w')
      source_detected = nil

      File.readlines(
        File.join(path, GEMFILE_BACKUP_FILE_NAME)
      ).each do |line|
        if line.start_with?('source') && source_detected.nil?
          source_detected = true
        elsif source_detected
          source_detected = false
          file.write("\n#{GEMFILE_PLUGIN_ENTRY}\n")
        end

        file.write(line)
      end

      file.close

      FileUtils.rm(File.join(path, GEMFILE_BACKUP_FILE_NAME))
    end
  end
end
