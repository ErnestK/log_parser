# frozen_string_literal: true

module Printers
  # Printer which print result in stdout
  # we can create different printers which can print result in file, db...
  # but we should create same methods, and put new printer in config.rb, and initialize it in main app
  class Stdout
    DELIMITER = '-------------------------'

    def print(str_data)
      p str_data
    end

    def print_reports(config)
      print_errors_if_exists(config)

      config.printer.print_uniq_visits(Repositories::Redis::UniqVisitsCount.new(config.redis).all_ordered)
      config.printer.print_all_visits(Repositories::Redis::VisitsCount.new(config.redis).all_ordered)
    end

    def print_errors_if_exists(config)
      return unless Repositories::Redis::Logger.new(config.redis).error_exists?

      print DELIMITER
      print 'Some error occurs: '
      Repositories::Redis::Logger.new(config.redis).all_errors.each { |model_log| print model_log.data }
      print DELIMITER
    end

    def print_uniq_visits(ordered_uniq_visits)
      print DELIMITER
      print 'Uniq visits: '
      ordered_uniq_visits.each { |data| print "#{data.endpoint} #{data.score} unique visits" }
      print DELIMITER
    end

    def print_all_visits(ordered_all_visits)
      print DELIMITER
      print 'All visits: '
      ordered_all_visits.each { |data| print "#{data.endpoint} #{data.score} visits" }
      print DELIMITER
    end
  end
end
