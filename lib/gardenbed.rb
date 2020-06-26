# frozen_string_literal: true

require 'gardenbed/key_manager'
require 'gardenbed/screen'
require 'gardenbed/version'
require 'gardenbed/window'

require 'curses'
require 'singleton'

# Module holding all the stuff
module Gardenbed
  SIGNALS = { run: 0, halt: 1 }.freeze

  class Error < StandardError; end

  def self.start
    @screen = Screen.new
    @screen
  end

  def self.new_window(height, width, x_pos, y_pos)
    @screen.new_window height, width, x_pos, y_pos
  end

  def self.new_key_manager
    KeyManager.new
  end

  def self.active_window=(active_window)
    @screen.active_window = active_window
  end

  def self.active_window
    @screen.active_window
  end

  # Initial Holder for everything else
  class Gardenbed
    include Singleton

    attr_reader :logger

    attr_reader :screen
    attr_reader :key_manager
    attr_accessor :run_signal

    def self.instance
      new
    end

    def start
      @screen = Screen.new
    end

    def halt!
      @run_signal = Gardenbed::SIGNALS[:halt]
      exit(0)
    end

    private

    def new
      file = File.open('foo.log', File::WRONLY | File::APPEND)
      # To create new logfile, add File::CREAT like:
      # file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
      @logger = Logger.new(file)
    end

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
