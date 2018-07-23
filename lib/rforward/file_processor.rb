class FileProcessor
  attr_accessor :filepath, :line_processor

  def initialize filepath, line_processor
    @filepath, @line_processor = filepath, line_processor
  end

  def call
    File.readlines(filepath).each do |line|
      line_processor.call line
    end
  end

  def self.call filepath
    processor = FileProcessor.new filepath, FFluentdLine.new
    processor.call
  end
end
