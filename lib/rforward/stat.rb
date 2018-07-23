class Stat
  include Singleton
  attr_accessor :success, :failed, :total, :files_total, :files_current, :flush_counter

  def initialize
    @success, @failed, @total, @files_total, @files_current, @flush_counter = 0, 0, 0, 0, 0, 0
  end

  def to_s
    text = []
    text << "[STAT]"
    text << "[total: #{total}] [success: #{success}] [failed #{failed}]"
    text << "[file current #{files_current}] [files total #{files_total}]"
    text << "[STAT]"
    text.join "\n"
  end
end
