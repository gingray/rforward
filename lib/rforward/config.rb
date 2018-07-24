class Config
  extend Dry::Container::Mixin
  include Singleton
  attr_accessor :config
  attr_accessor :root_path
  attr_accessor :current_uploader

  FLUENTD = 'fluentd'.freeze
  ELASTIC = 'elastic'.freeze

  FLUENTD_CLIENT = 'flunetd_client'.freeze
  ELASTIC_CLIENT = 'elastic_client'.freeze

  def load_config config_path
    @config = YAML.load_file config_path
  end

  def [](key)
    config = @config || sample
    config[key.to_s]
  end

  def create_sample_config config_path
    RLogger.instance.info "Config created (#{config_path})"

    File.open(config_path, "w") do |file|
      file.write sample.to_yaml
    end
  end

  private

  def sample
    {
      'file_mask' => '**.log',
      'fluentd' => {
        'host' => 'localhost',
        'port' => 24224,
        'tag' => 'event'
      },
      'elastic' => {
        'host' => 'localhost',
        'port' => 9200,
        'user' => '',
        'password' => '',
        'scheme' => 'http',
        'batch_size' => 1,
        'index_name' => 'fluentd-'
      },
      'flush_delay' => 20,
      'flush_threshold' => 100_000,
      'time_key' => 'time',
      'time_format' => '%Y-%m-%dT%H:%M:%S%z',
      'index_key' => 'index_key'
    }
  end
end
