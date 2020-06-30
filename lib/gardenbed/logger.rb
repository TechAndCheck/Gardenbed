# frozen_string_literal: true

require 'singleton'

module Gardenbed # rubocop:disable Style/Documentation
  # Returns the logger for the app, creating one if it doesn't exist already
  # From here things such at `.info` and `.warn` work just fine.
  def self.logger
    Logging.instance.logger
  end

  # Manager loggers
  class Logging
    include Singleton
    LOG_FILE_NAME = './logs/development.log'

    attr_reader :logger

    # Keeps the logger from being overwritten somehow
    def logger=
      # NOTE: in the future this could be overwritten by someone looking to overwrite with their
      # own logger.
      raise 'Logger cannot be overwritten'
    end

    private

    def initialize
      @logger = Logger.new(LOG_FILE_NAME)
      @logger.level = Logger::INFO
    end
  end
end
