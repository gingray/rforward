require 'pathname'

class DirectoryProcessor
  attr_accessor :path

  def initialize path
    @path = path
  end

  def call
    files_arr = Dir["#{path}/#{Config.instance['file_mask']}"]
    files_arr = files_arr.select { |file| File.file? file } 
    Stat.instance.files_total = files_arr.count
    files_arr.each do |filepath|
      FileProcessor.call filepath
    end
  end

  def self.call path
    path = Pathname.new path
    raise WrongPathEx, path unless path.directory? && path.exist?
    processor = DirectoryProcessor.new path.to_path
    processor.call
  end
end
