# frozen_string_literal: true

module Diffend
  # Executes a check for a given command
  module Execute
    class << self
      # Build verdict
      #
      # @param config [Diffend::Config]
      def call(config)
        Diffend::RequestVerdict
          .call(config, build_definition(config.command))
          .tap { |response| build_message(config, response) }
      rescue Diffend::Errors::DependenciesResolveException
        # We are unable to resolve dependencies, no message will be printed
      end

      # Build bundler definition
      #
      # @return [::Bundler::Definition]
      def build_definition(command)
        Diffend::BuildBundlerDefinition.call(
          command,
          ::Bundler.default_gemfile,
          ::Bundler.default_lockfile
        )
      end

      # @param config [Diffend::Config]
      # @param response [Hash] response from diffend API
      def build_message(config, response)
        if response.key?('error')
          build_error(config, response)
        elsif response.key?('action')
          build_verdict(config, response)
        else
          Diffend::HandleErrors::Report.call(
            config: config,
            message: :unsupported_response,
            payload: response,
            report: true
          )
        end
      end

      # @param config [Diffend::Config]
      # @param response [Hash] response from diffend API
      def build_error(config, response)
        build_error_message(response)
          .tap(&config.logger.method(:error))

        raise Diffend::Errors::HandledException
      end

      # @param config [Diffend::Config]
      # @param response [Hash] response from diffend API
      def build_verdict(config, response)
        case response['action']
        when 'allow'
          build_allow_message(config.command, response)
            .tap(&config.logger.method(:info))
        when 'warn'
          build_warn_message(config.command, response)
            .tap(&config.logger.method(:warn))
        when 'deny'
          build_deny_message(config.command, response)
            .tap(&config.logger.method(:error))

          exit 1 unless ENV.key?('DIFFEND_SKIP_DENY')
        else
          Diffend::HandleErrors::Report.call(
            config: config,
            message: :unsupported_verdict,
            payload: response,
            report: true
          )
        end
      end

      # @param response [Hash] response from diffend API
      #
      # @return [String]
      def build_error_message(response)
        <<~MSG
          \nDiffend returned an error for your request.\n
          #{response['error']}\n
        MSG
      end

      # @param command [String] command executed via bundler
      # @param response [Hash] response from diffend API
      #
      # @return [String]
      def build_allow_message(command, response)
        <<~MSG
          #{build_message_header('an allow', command)}
          #{build_message_info(response)}\n
          #{response['review_url']}\n
        MSG
      end

      # @param command [String] command executed via bundler
      # @param response [Hash] response from diffend API
      #
      # @return [String]
      def build_warn_message(command, response)
        <<~MSG
          #{build_message_header('a warn', command)}
          #{build_message_info(response)} Please go to the url below and review the issues.\n
          #{response['review_url']}\n
        MSG
      end

      # @param command [String] command executed via bundler
      # @param response [Hash] response from diffend API
      #
      # @return [String]
      def build_deny_message(command, response)
        <<~MSG
          #{build_message_header('a deny', command)}
          #{build_message_info(response)} Please go to the url below and review the issues.\n
          #{response['review_url']}\n
        MSG
      end

      # @param type [String] verdict type
      # @param command [String] command executed via bundler
      #
      # @return [String]
      def build_message_header(type, command)
        "\nDiffend reported #{type} verdict for #{command} command for this project."
      end

      # @param response [Hash] response from diffend API
      #
      # @return [String]
      def build_message_info(response)
        "\nQuality score: #{response['quality_score']}, allows: #{response['allows_count']}, warnings: #{response['warns_count']}, denies: #{response['denies_count']}."
      end
    end
  end
end
