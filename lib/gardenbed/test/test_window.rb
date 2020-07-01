require './test_gardenbed.rb'

module Gardenbed
  # Test window.rb
  class TestWindow < TestGardenbed
    def test_window
      assert_instance_of(Window.class, Window.new(1, 1, 1, 1))
    end
  end
end
