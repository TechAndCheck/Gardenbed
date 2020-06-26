# frozen_string_literal: true

require 'erb'

module Gardenbed
  # Manager for a Curses Window
  # Make sure you've initialized a Screen first, or this will fail in fun ways
  #
  # There's two ways to manage this content
  # It can either be a string (such as from a keyboard) or a template with a backing data set
  # For string call `string_value=` to write to the content. This content is always appended, so that
  # if you're typing it's always adding
  #
  # The second way to set this up is by setting `template=` which takes in an erb string
  # You then update the variables in the template by setting `data_hash=`, this will redraw the template
  # and update the content.
  #
  # Internally this is all done using the `@update_queue` `Queue` object, so if multiple changes are
  # written at any given time they're all run (more or less, there's going to be optimizations so that
  # not everything is run if eventually one of the changes overwrites the previous ones)
  class Window
    SIGNALS = { run: 0, halt: 1 }.freeze

    # This is a struct designed for the `@update_queue`
    # +content+: A string containing the content to add
    # +update_type+: An UpdateQueueObject::UPDATE_TYPES, for now `:append` or `:replace`
    UpdateQueueObject = Struct.new(:content, :update_type) do
      UPDATE_TYPES = { append: 0, replace: 1 }.freeze
    end

    # This is a struct to indicate a point in the window
    Point = Struct.new(:x, :y)

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

      # The current location of the cursor
      @cursor_point = Point.new(0, 0)
      # The "start" point of the cursor, usually the start of the line
      @cursor_zero_point = Point.new(0, 0)

      @string_value = ''
      @data_hash = {}

      # Sets up the queue for updates
      @update_queue = Queue.new

      redraw
    end

    def update
      # If the update string is empty or equal to what we already have in the window
      # return unless should_update_window?

      # Update the string values and redraw the string
      # Run through the current `@update_queue` and draw it all out
      # if it's a :replace, then replace, if it's an :append, then append
      until @update_queue.empty?
        update_queue_object = @update_queue.pop

        case update_queue_object.update_type
        when UPDATE_TYPES[:append]
          self.string_value += update_queue_object.content
        when UPDATE_TYPES[:replace]
          self.string_value = update_queue_object.content
        else
          raise 'Incorrect update type provided to update queue.'
        end
      end

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
      @update_queue << UpdateQueueObject.new(compose_template, UPDATE_TYPES[:replace])
    end

    def update_string_value(string)
      @update_queue << UpdateQueueObject.new(string, UPDATE_TYPES[:append])
    end

    def border_vertical=(symbol)
      @border_vertical = symbol
      set_border

      # Set the cursor zero point to accommodate the border difference
      @cursor_zero_point = Point.new(@cursor_zero_point.x, 1)
      redraw
    end

    def border_horizontal=(symbol)
      @border_horizontal = symbol
      set_border

      # Set the cursor zero point to accommodate the border difference
      @cursor_zero_point = Point.new(1, @cursor_zero_point.y)
      redraw
    end

    # Set where the cursor should be in the line
    def cursor_point=(point)
      @cursor_point = point
      @window.setpos point.x, point.y
      redraw
    end

    # Reset the cursor point to the cursor zero point (usually the start of the line)
    def reset_cursor_point
      self.cursor_point = @cursor_zero_point
    end

    def string_value=(string_value)
      return if string_value == @string_value

      clear_string_value
      @string_value = string_value.to_s
      self.cursor_point = @cursor_point

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
      # return_value = true
      # return_value = false if @update_string_value&.empty?
      # return_value = false if @update_string_value == @string_value

      !@update_queue.empty?
    end
  end
end
