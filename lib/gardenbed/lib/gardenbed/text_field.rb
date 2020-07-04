# frozen_string_literal: true
require 'curses'

module Gardenbed
  # Manage cursor position, backspace, etc.
  class TextField
    # This is a struct to indicate a point in the window
    Point = Struct.new(:x, :y)

    attr_reader :content, :cursor

    # A hash of special keys and functions for when we're writing stuff
    # mostly refers to this: https://man7.org/linux/man-pages/man7/ascii.7.html / http://www.asciitable.com/
    # Also some of this: https://www.bigsmoke.us/readline/shortcuts
    SPECIAL_KEYS = {
      "#{Curses::Key::BACKSPACE}": :backspace,
      "#{Curses::Key::DC}": :forward_delete,
      "#{Curses::Key::LEFT}": :left,
      "#{Curses::Key::RIGHT}": :right,
      '\e': :escape
    }.freeze

    def initialize
      # Create a cursor if the leaf if nil
      @cursor = Cursor.new
      @content = ''
    end

    def append(character)
      character_symbol = character.to_sym
      if SPECIAL_KEYS.key? character_symbol
        send SPECIAL_KEYS[character_symbol]
      else
        @content = @content.dup.insert @cursor.position.x, character
        @cursor.advance(character.size)
      end
    end

    def cursor_color
      @cursor.color
    end

    private

    # Special keys handling

    # Delete character one behind the cursor, if it's at the beginning do nothing
    def backspace
      @content.slice!(@cursor.position.x - 1)
      @cursor.retreat
    end

    # Delete the character under the cursor
    def forward_delete
      @content.slice!(@cursor.position.x)
    end

    # Move the cursor left
    def left
      @cursor.retreat
    end

    # Move the cursor right
    def right
      return if cursor.position.x + 1 > @content.length
      @cursor.advance
    end

    def escape; end
  end
end
