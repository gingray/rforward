require "rforward/version"
require 'singleton'
require 'yaml'
require 'json'
require 'dry-container'
require 'time'
require 'elasticsearch'
require "rforward/exceptions"
require "rforward/stat"
require "rforward/rlogger"
require "rforward/directory_processor"
require "rforward/file_processor"
require "rforward/uploaders/fluentd_forward"
require "rforward/uploaders/elastic"
require "rforward/config"
require 'thor'

module Rforward
  class CLI < Thor
    desc "process_logs [path] [uploader]", "Process JSON logs into Fluentd Forward or Elastic"

    def process_logs path, uploader
      check_config
      dependencies
      select_uploader uploader
      DirectoryProcessor.call path
      RLogger.instance.info "#{path} logs extensions #{Config.instance['file_mask']}"
      puts "Work finidhed press any key"
      STDIN.gets
    rescue ConfigNotFoundEx => e
      RLogger.instance.error e.message
    end

    desc "create_config", "Create config file in current working directory"

    def create_config
      Config.instance.create_sample_config config_path
    rescue ConfigNotFoundEx => e
      RLogger.instance.error e.message
    end

    private

    def check_config
      raise ConfigNotFoundEx, config_path.to_path unless config_path.file? && config_path.exist?
      Config.instance.load_config config_path
    end

    def config_path
      @config_path ||= Pathname.new(File.join(ENV['ROOT_PATH'], 'rforward.yml'))
    end

    def select_uploader uploader
      if uploader == Config::FLUENTD
        Config.instance.current_uploader = Config::FLUENTD
        return
      end

      if uploader == Config::ELASTIC
        Config.instance.current_uploader = Config::ELASTIC
        return
      end
      raise NoUploaderSelected, uploader
    end

    def dependencies
      Config.register Config::FLUENTD_CLIENT do
        host, port = Config.instance['fluentd']['host'], Config.instance['fluentd']['port']
        Fluent::Logger::FluentLogger.new(nil, host: host, port: port.to_i)
      end

      Config.register Config::ELASTIC_CLIENT do
        Elasticsearch::Client.new hosts: [
          {
              host: Config.instance['elastic']['host'],
              port: Config.instance['elastic']['port'],
              user: Config.instance['elastic']['user'],
              password: Config.instance['elastic']['password'],
              scheme: Config.instance['elastic']['scheme']
          }
        ],
        retry_on_failure: true,
        reload_connections: true
      end

      Config.register Config::FLUENTD do
        Rforward::Uploaders::FluentdForward.new
      end

      Config.register Config::ELASTIC do
        Rforward::Uploaders::Elastic.new
      end
    end
  end
end
