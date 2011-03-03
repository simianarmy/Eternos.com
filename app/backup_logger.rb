# BackupLogger
#
# Simple logging helper module
# Usage:
# include BackupLogger
# BackupLogger.logger = Rails.logger

module BackupLogger
  @logger = nil
  attr_accessor :logger
  
  def log_info(*args)
    log :info, *args
  end

  def log_debug(*args)
    log :debug, *args
  end

  def log(level, *args)
    unless logger
      puts args.join("\n")
      return
    end
      
    case level
    when :debug
      logger.debug args.join("\n")
    when :info
      logger.info args.join("\n")
    when :warn
      logger.warn args.join("\n")
    when :error
      logger.error args.join("\n")
    end
  end
end