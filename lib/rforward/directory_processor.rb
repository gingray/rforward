require 'pathname'

class DirectoryProcessor
  attr_accessor :path, :ext

  def initialize path, ext
    @path, @ext = path, ext
  end

  def call
    files_arr = Dir["#{path}/**#{ext}"]
    files_arr = files_arr.select { |file| File.file? file } 
    Stat.instance.files_total = files_arr.count
    files_arr.each do |filepath|
      FileProcessor.call filepath
    end
  end

  def self.call path, ext
    path = Pathname.new path
    raise WrongPathEx, path unless path.directory? && path.exist?
    processor = DirectoryProcessor.new path.to_path, ext
    processor.call
  end
end
