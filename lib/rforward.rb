require "rforward/version"
require 'singleton'
require 'yaml'
require 'json'
require 'dry-container'
require 'time'
require "rforward/exceptions"
require "rforward/stat"
require "rforward/rlogger"
require "rforward/directory_processor"
require "rforward/file_processor"
require "rforward/ffluentd_line"
require "rforward/config"
require 'thor'

module Rforward
  class CLI < Thor
    desc "process_logs", "Process JSON logs into Fluentd Forward"
    def process_logs path, ext=".log"
      check_config
      dependencies
      DirectoryProcessor.call path, ext
      RLogger.instance.info "#{path} logs extensions #{ext}"
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

    def dependencies
      Config.register Config::FLUENTD do
        host, port, tag = Config.instance[:fluentd_host], Config.instance[:fluentd_port], Config.instance[:tag]
        Fluent::Logger::FluentLogger.new(nil, host: host, port: port.to_i)
      end
    end
  end
end
