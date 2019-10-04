# frozen_string_literal: true

module Gardenbed
  # Manages key presses, mapping for alt keys etc.
  class KeyManager
    MODIFIER_KEY_MAP = { alt: 'A', ctrl: 'C' }.freeze
    TEXT_MODES = %i[full off modifier_check].freeze

    def intialize
      super()
      @mode = :off
      @current_modifier_key = nil unless @current_modifier_key.nil? == false
      @keymappings = {}
    end

    def character_for_keypress(keypress)
      if keypress == 27
        @current_modifier_key = :alt
        return
      else
        value = case keypress
                when Curses::Key::LEFT
                  'Left Key'
                when Curses::Key::RIGHT
                  'Right Key'
                when Curses::Key::UP
                  'Up Key'
                when Curses::Key::DOWN
                  'Down Key'
                when 127
                  'Back!!!!'
                when Curses::Key::DC
                  'Deleting Forward!!!'
                when 10
                  'Enter'
                when ?\C-s
                  'ctrl s'
                else
                  keypress
                end
      end

      unless @current_modifier_key.nil?
        value = "#{MODIFIER_KEY_MAP[@current_modifier_key]}-#{value}"
        @keymappings[value]&.call
        @current_modifier_key = nil
        return
      end

      value.to_s
    end

    def register_key_mapping(key, &block)
      @keymappings = {} if @keymappings.nil?
      @keymappings[key] = block
    end
  end
end
