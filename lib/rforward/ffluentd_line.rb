require 'fluent-logger'

class FFluentdLine
  attr_accessor :client, :host, :port, :tag

  def initialize
    @client = Config.resolve Config::FLUENTD
  end

  def call line
    json = JSON.parse line
    @client.post Config.instance[:tag], json
    true
  rescue Exception => e
    RLogger.instance.error "(#{e.message}) (line: #{line})"
    false
  end
end
