# frozen_string_literal: true

module Gardenbed
  # Manages a cursor
  class Cursor
    # The color of the cursor
    attr_reader :color, :position

    def initialize
      @position = Point.new(0, 0)
      # Create a color and enable the cursor if leaf is nil
      Curses.init_pair(Curses::COLOR_CYAN, Curses::COLOR_WHITE, Curses::COLOR_CYAN)
      @color = Curses::COLOR_CYAN
    end

    # Move the cursor one spot forward. Eventually, when we get to multi line mode, this will get
    # more complicated
    def advance(distance = 1)
      @position.x += distance
    end

    # Move the cursor one spot backwards. Eventually, when we get to multi line mode, this will get
    # more complicated
    def retreat(distance = 1)
      # Don't let the cursor get below zero
      return if @position.x < distance

      @position.x -= distance
    end
  end
end
