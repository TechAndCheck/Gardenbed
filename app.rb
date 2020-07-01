# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# Groundskeeper is a manager for FactStream video streams.
class Sapling < Gardenbed::FlowerBox
  # This function is the only one required.
  #
  # This is the entry point, start to create windows, setup what they do, etc. here.
  # DELETE ME: below is a demo that shows two windows, one that shows a clock, one you can type in.
  def start
    # Create the text window for typing
    text_window = setup_text_window
    # Create a window showing a clock
    clock_window = setup_clock_window

    # Set up an update loop to update the clock.
    # In real apps you would update your various windows' status
    setup_loop(text_window, clock_window)
  end

  def setup_text_window
    # Set up a window that will just show text that's typed (setup loop will make that happen)
    # Here we pass in `nil` for the template name since we want it to be blank
    window = Gardenbed.new_window nil, 3, Curses.cols, Curses.lines - 3, 0
    window.border_vertical = '|'
    window.border_horizontal = '='
    window
  end

  def setup_clock_window
    # Set up a window that will show a clock from within a template
    # We pass in `:time` as the name for the template. This is assumed to be the name of the erb
    # view in the `views` folder.
    window2 = Gardenbed.new_window :time, Curses.lines - 3, Curses.cols, 0, 0
    window2.border_vertical = '+'
    window2.border_horizontal = '-'
    window2
  end

  def setup_loop(text_window, clock_window)
    # Setting the `active_window` is the window that will take in text and display it from being typed
    Gardenbed.active_window = text_window

    # A basic loop that updates the `clock_window` with the formatted time to show every 0.1 seconds
    loop do
      time = Time.now.strftime('%FT%T%:z')
      clock_window.update_data(time: time)
      sleep 0.1
    end
  end
end
