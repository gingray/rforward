class RLogger
  include Singleton

  def info msg
    puts "[INFO] #{msg}"
  end

  def error msg
    puts "[ERROR] #{msg}"
  end
end
