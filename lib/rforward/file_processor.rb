class FileProcessor
  attr_accessor :filepath, :line_processor

  def initialize filepath, line_processor
    @filepath, @line_processor = filepath, line_processor
  end

  def call
    RLogger.instance.info "start working on #{filepath}"
    File.readlines(filepath).each do |line|
      line_processor.call line
    end
    Stat.instance.files_current += 1
    RLogger.instance.info "finish working on #{filepath}"
    RLogger.instance.stat
  end

  def self.call filepath
    processor = FileProcessor.new filepath, FFluentdLine.new
    processor.call
  end
end
