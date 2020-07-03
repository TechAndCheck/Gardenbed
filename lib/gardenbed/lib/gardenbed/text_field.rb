# frozen_string_literal: true
require 'curses'
module Gardenbed
  # Manage cursor position, backspace, etc.
  class TextField
    # This is a struct to indicate a point in the window
    Point = Struct.new(:x, :y)

    attr_reader :content

    # A hash of special keys and functions for when we're writing stuff
    # mostly refers to this: https://man7.org/linux/man-pages/man7/ascii.7.html / http://www.asciitable.com/
    # Also some of this: https://www.bigsmoke.us/readline/shortcuts
    SPECIAL_KEYS = {
      "#{Curses::Key::BACKSPACE}": :backspace,
      "#{Curses::Key::DC}": :forward_delete,
      '\e': :escape
    }.freeze

    def initialize
      @cursor_point = Point.new(0, 0)
      @content = ''
    end

    def append(character)
      character_symbol = character.to_sym
      if SPECIAL_KEYS.key? character_symbol
        send SPECIAL_KEYS[character_symbol]
      else
        @content += character
        advance_cursor(character.size)
      end
    end

    private

    # Special keys handling

    # Delete character one behind the cursor, if it's at the beginning do nothing
    def backspace
      @content.slice!(@cursor_point.x - 1)
      retreat_cursor
    end

    # Delete the character under the cursor
    def forward_delete
      @content.slice!(@cursor_point.x)
    end

    def escape; end

    # Cursor management

    # Move the cursor one spot forward. Eventually, when we get to multi line mode, this will get
    # more complicated
    def advance_cursor(distance = 1)
      @cursor_point.x += distance
    end

    # Move the cursor one spot backwards. Eventually, when we get to multi line mode, this will get
    # more complicated
    def retreat_cursor(distance = 1)
      # Don't let the cursor get below zero
      return if @cursor_point.x < distance

      @cursor_point.x -= distance
    end
  end
end
