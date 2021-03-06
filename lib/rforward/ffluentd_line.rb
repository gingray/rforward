require 'fluent-logger'

class FFluentdLine
  attr_accessor :client, :host, :port, :tag

  def initialize
    @client = Config.resolve Config::FLUENTD
  end

  def call line
    Stat.instance.total += 1
    json = JSON.parse line
    json = mutate json
    @client.post Config.instance[:tag], json
    Stat.instance.success += 1
    Stat.instance.flush_counter += 1
    true
  rescue Exception => e
    Stat.instance.failed += 1
    RLogger.instance.error "(#{e.message}) (line: #{line})"
    false
  end

  def mutate record
    return record unless record[Config.instance['time_key']]
    time = Time.strptime record[Config.instance['time_key']], Config.instance['time_format']
    record[Config.instance['index_key']] = "fluentd-#{time.strftime('%Y-%m')}"
    record
  end

end
