class BaseRforwardEx < StandardError
end

class WrongPathEx < BaseRforwardEx
  def initialize path
    super("(#{path}) path must be exist and must be a directory ")
  end
end

class ConfigNotFoundEx < BaseRforwardEx
  def initialize config
    super("(#{config}) config yml not found create config first 'rforward create config'")
  end
end

