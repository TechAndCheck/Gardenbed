# frozen_string_literal: true

require 'erb'

module Gardenbed
  # Manager for a Curses Window
  # Make sure you've initialized a Screen first, or this will fail in fun ways
  class Window
    attr_reader :border_vertical, :border_horizontal
    attr_reader :cursor_x, :cursor_y

    attr_reader :string_value
    attr_reader :template

    def initialize(height, width, x_pos, y_pos)
      @window = Curses::Window.new height, width, x_pos, y_pos
      @window.keypad = true
      @window.nodelay = true

      @border_vertical = ' '
      @border_horizontal = ' '
      @cursor_x = 0
      @cursor_y = 0
      @string_value = ''
      @data_hash = {}

      redraw
    end

    def add_test_string
      self.string_value = "Test 123"
    end

    def template=(template)
      formatted_template = ERB.new(template, trim_mode: '%<>')
      @template = template
      update_data(@data_hash)
    end

    def update_data(data_hash)
      @data_hash = data_hash
      self.string_value = compose_template
      redraw
    end

    def border_vertical=(symbol)
      @border_vertical = symbol
      set_border
      redraw
    end

    def border_horizontal=(symbol)
      @border_horizontal = symbol
      set_border
      redraw
    end

    def set_cursor_position(x_pos, y_pos)
      @cursor_x = x_pos
      @cursor_y = y_pos
      @window.setpos x_pos, y_pos
      redraw
    end

    def string_value=(string_value)
      return if string_value == @string_value

      clear_string_value
      @string_value = string_value.to_s
      set_cursor_position @cursor_x, @cursor_y
      @window.addstr @string_value
      redraw
    end

    def clear_string_value
      @string_value = ''
      @window.clear
      set_border
      # We only want to clear, not do anything else, so do a raw refresh.
      @window.refresh
    end

    def wait_for_key_char
      @window.getch
    end

    private

    def set_border
      @window.box @border_vertical, @border_horizontal, ' '
      redraw
    end

    def redraw
      @template.nil?  ? Curses.curs_set(0) : Curses.curs_set(1)
      @window.refresh
    end

    def compose_template
      return if @template.nil?

      begin
        built_template = ERB.new(template, trim_mode: '%<>')
        built_template.result_with_hash @data_hash
      rescue StandardError => e
        # TODO: Properly handle this, probably raise and error with missing data
        e
        # raise e
      end
    end
  end
end
