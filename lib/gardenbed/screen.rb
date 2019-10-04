# frozen_string_literal: true

module Gardenbed
  # Manager for Curses screen
  # Make sure to call this before you draw anything
  class Screen
    def initialize
      at_exit do
        close_screen
      end

      start_screen
    end

    def new_window(height, width, x_pos, y_pos)
      Curses::Window.new height, width, x_pos, y_pos
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
  end
end
