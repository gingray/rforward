require 'pathname'

class DirectoryProcessor
  attr_accessor :path, :ext

  def initialize path, ext
    @path, @ext = path, ext
  end

  def call
    Dir["#{path}/**#{ext}"].each do |filepath|
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
