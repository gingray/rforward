require 'fluent-logger'

class FFluentdLine
  attr_accessor :client, :host, :port, :tag

  def initialize
    @client = Config.resolve Config::FLUENTD
  end

  def call line
    Stat.instance.total += 1
    json = JSON.parse line
    @client.post Config.instance[:tag], json
    Stat.instance.success += 1
    true
  rescue Exception => e
    Stat.instance.failed += 1
    RLogger.instance.error "(#{e.message}) (line: #{line})"
    false
  end
end
