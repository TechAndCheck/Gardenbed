# frozen_string_literal: true

module Gardenbed
  # Manager for Curses screen
  # Make sure to call this before you draw anything
  class Screen
    # The speed of the update, in seconds
    CLOCKSPEED = 0.001

    attr_reader :active_window

    def initialize
      at_exit do
        close_screen
      end

      start_screen
      @windows = []

      create_tracking_window
      start_update_thread
    end

    def new_window(name, height, width, x_pos, y_pos)
      window = Window.new(name, height, width, x_pos, y_pos)
      @windows << window
      window
    end

    def active_window=(active_window)
      @active_window = active_window
      begin_key_watch
    end

    private

    def start_screen
      Curses.init_screen
      Curses.start_color if Curses.has_colors?
      Curses.cbreak
      Curses.noecho
      # Curses.raw
    end

    def close_screen
      Curses.close_screen
    end

    def create_tracking_window
      @tracking_window = Window.new(nil, 0, 0, 0, 0)
      @windows << @tracking_window
    end

    def begin_key_watch
      Thread.new do
        loop do
          return if @active_window.nil?

          key = @tracking_window.wait_for_key_char
          character = Gardenbed::Application.instance.key_manager.character_for_keypress(key) unless key.nil?
          @active_window.update_string_value(character) unless character.nil?
        end
      end

      Thread.abort_on_exception = true
    end

    def start_update_thread
      Thread.new do
        loop do
          @windows.each(&:update)
          @active_window&.reset_cursor_point

          sleep CLOCKSPEED
        end
      end

      Thread.abort_on_exception = true
    end
  end
end
