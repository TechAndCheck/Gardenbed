# frozen_string_literal: true

require 'gardenbed/key_manager'
require 'gardenbed/screen'
require 'gardenbed/version'
require 'gardenbed/window'
require 'gardenbed/logger'
require 'gardenbed/flowerbox'
require 'gardenbed/leaf'

require 'curses'
require 'singleton'
require 'logger'
require 'byebug/core'

# Module holding all the stuff
module Gardenbed
  SIGNALS = { run: 0, halt: 1 }.freeze

  class Error < StandardError; end

  def self.start
    logger.info 'Planting Gardenbed...'
    Byebug.start_server 'localhost', ENV.fetch('BYEBUG_SERVER_PORT', 1048).to_i
    # Sleep two seconds to wait for the debugger to actually attach to the remote session
    # If you're having problem debugging on startup, extend this probably.
    sleep 2
    Application.instance.start
  end

  def self.new_window(name, height, width, x_pos, y_pos)
    Application.instance.new_window name, height, width, x_pos, y_pos
  end

  def self.key_manager
    Application.instance.key_manager
  end

  def self.active_window=(active_window)
    Application.instance.active_window = active_window
  end

  def self.active_window
    Application.instance.active_window
  end

  # Initial Holder for everything else
  class Application
    include Singleton

    attr_reader :logger

    attr_reader :screen
    attr_reader :key_manager
    attr_accessor :run_signal

    def start
      @screen = Screen.new
    end

    def new_window(name, height, width, x_pos, y_pos)
      @screen.new_window name, height, width, x_pos, y_pos
    end

    def key_manager
      @key_manager = KeyManager.new if @key_manager.nil?
      @key_manager
    end

    def active_window=(active_window)
      @screen.active_window = active_window
    end

    def active_window
      @screen.active_window
    end

    def halt!
      @run_signal = Gardenbed::SIGNALS[:halt]
      exit(0)
    end

    private

    def initialize
      @run_signal = SIGNALS[:run]
      setup_keymapping
    end

    def setup_keymapping
      @key_manager = KeyManager.new
      @key_manager.register_key_mapping 'A-n' do
        halt!
      end
    end
  end
end
