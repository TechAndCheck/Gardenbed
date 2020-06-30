# frozen_string_literal: true

require 'gardenbed/key_manager'
require 'gardenbed/screen'
require 'gardenbed/version'
require 'gardenbed/window'
require 'gardenbed/logger'

require 'curses'
require 'singleton'
require 'logger'

# Module holding all the stuff
module Gardenbed
  SIGNALS = { run: 0, halt: 1 }.freeze

  class Error < StandardError; end

  def self.start
    logger.info 'Planting Gardenbed...'
    Planter.instance.start
  end

  def self.new_window(height, width, x_pos, y_pos)
    Planter.instance.new_window height, width, x_pos, y_pos
  end

  def self.key_manager
    Planter.instance.key_manager
  end

  def self.active_window=(active_window)
    Planter.instance.active_window = active_window
  end

  def self.active_window
    Planter.instance.active_window
  end

  # Initial Holder for everything else
  class Planter
    include Singleton

    attr_reader :logger

    attr_reader :screen
    attr_reader :key_manager
    attr_accessor :run_signal

    def start
      @screen = Screen.new
    end

    def self.new_window(height, width, x_pos, y_pos)
      @screen.new_window height, width, x_pos, y_pos
    end

    def self.key_manager
      @key_manager = KeyManager.new if @key_manager.nil?
      @key_manager
    end

    def self.active_window=(active_window)
      @screen.active_window = active_window
    end

    def self.active_window
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
