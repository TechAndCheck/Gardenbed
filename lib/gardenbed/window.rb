# frozen_string_literal: true

require 'erb'

module Gardenbed
  # Manager for a Curses Window
  # Make sure you've initialized a Screen first, or this will fail in fun ways
  class Window
    SIGNALS = { run: 0, halt: 1 }.freeze

    attr_reader :border_vertical, :border_horizontal
    attr_reader :cursor_x, :cursor_y

    attr_reader :string_value
    attr_reader :template

    attr_accessor :update_string_value

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
      @update_string_value = ''

      redraw
    end

    def update
      # If the update string is empty or equal to what we already have in the window
      return unless should_update_window?

      # Update the string values and redraw the string
      self.string_value += @update_string_value
      @update_string_value = ''
      redraw
    end

    def add_test_string
      self.string_value = 'Test 123'
    end

    def template=(template)
      @template = template
      update_data(@data_hash)
    end

    def update_data(data_hash)
      @data_hash.merge! data_hash
      @update_string_value = compose_template
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
      @template.nil? ? Curses.curs_set(0) : Curses.curs_set(1)
      @window.refresh
    end

    def compose_template
      return if @template.nil?

      begin
        built_template = ERB.new(template, trim_mode: '%<>')
        built_template.result_with_hash @data_hash
      rescue NameError => e
        # If a data element isn't include for the template, add it to the data hash and then compose again.
        # This is so we don't error out if a variable hasn't been set yet.
        @data_hash[e.name] = ''
        compose_template
      end
    end

    def should_update_window?
      return_value = true
      return_value = false if @update_string_value&.empty?
      return_value = false if @update_string_value == @string_value

      return_value
    end
  end
end
