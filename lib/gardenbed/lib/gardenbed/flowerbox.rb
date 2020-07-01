# frozen_string_literal: true

module Gardenbed
  # All application files should inherent from this class, it gives you all the good stuff
  class FlowerBox
    def initialize
      Gardenbed.start

      # Assume that the child class implements `start`
      start
    end

    def start
      raise '`start` must be implemented in the class that inherits from this class.'
    end
  end
end
