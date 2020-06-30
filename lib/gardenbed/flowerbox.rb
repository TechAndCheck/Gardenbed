# frozen_string_literal: true

module Gardenbed
  # All application files should inherent from this class, it gives you all the good stuff
  class FlowerBox
    def initialize
      Gardenbed.start
    end
  end
end
