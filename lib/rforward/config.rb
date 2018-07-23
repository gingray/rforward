class Config
  extend Dry::Container::Mixin
  include Singleton
  attr_accessor :config
  attr_accessor :root_path

  FLUENTD = :flunetd.freeze

  def load_config config_path
    config = YAML.load_file config_path
  end

  def [](key)
    config = config || sample
    config[key.to_s]
  end

  def create_sample_config config_path
    RLogger.instance.info "Config created (#{config_path})"

    File.open(config_path,"w") do |file|
      file.write sample.to_yaml
    end
  end

  private

  def sample
    hash = {
      fluentd_host: 'localhost',
      fluentd_port: '24224',
      tag: 'event'
    }
  end
end
