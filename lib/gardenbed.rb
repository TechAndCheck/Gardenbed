# frozen_string_literal: true

require 'gardenbed/key_manager'
require 'gardenbed/screen'
require 'gardenbed/version'
require 'gardenbed/window'

require 'curses'

module Gardenbed
  class Error < StandardError; end

  def self.start
    @screen = Screen.new
  end

  def self.new_window(height, width, x_pos, y_pos)
    Window.new height, width, x_pos, y_pos
  end

  def self.new_key_manager
    KeyManager.new
  end

  class Gardenbed
    attr_reader :screen

    def initialize; end

    def start
      @screen = Screen.new
    end
  end
end

