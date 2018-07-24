class FileProcessor
  attr_accessor :filepath, :uploader

  def initialize filepath, uploader
    @filepath, @uploader = filepath, uploader
  end

  def call
    RLogger.instance.info "start working on #{filepath}"
    uploader.before_start
    File.readlines(filepath).each do |line|
      uploader.call line
    end
    uploader.after_finish
    Stat.instance.files_current += 1
    RLogger.instance.info "finish working on #{filepath}"
    RLogger.instance.stat
    delay
  end


  def delay
    if Config.instance['flush_threshold'].to_i < Stat.instance.flush_counter
      RLogger.instance.info "Sleep for #{Config.instance['flush_delay']} seconds"
      sleep(Config.instance['flush_delay'].to_i)
      Stat.instance.flush_counter = 0
    end
  end

  def self.call filepath
    uploader = Config.resolve Config.instance.current_uploader
    processor = FileProcessor.new filepath, uploader
    processor.call
  end
end
