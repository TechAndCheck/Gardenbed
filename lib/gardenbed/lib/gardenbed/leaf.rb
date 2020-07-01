# frozen_string_literal: true

# require 'hashdiff'

module Gardenbed
  # Leaves are views, I'm cute like that
  class Leaf
    attr_reader :name
    attr_reader :data

    def initialize(name)
      @name = name
      # find view file and pull in the erb
      @template = read_view_file
    end

    def data=(data)
      # TODO: Compare data to @data to see if we actually need an update
      # The best way to do this is probably Hashdiff (required above, but commented out)

      @data = data
      @composed_template = compose
    end

    def content
      @composed_template
    end

    private

    def view_name
      @view_name ||= "#{@name}.erb"
    end

    def read_view_file
      path = "views/#{view_name}"
      raise "Expected to find view file `#{path}`" unless File.file?(path)

      File.read(path)
    end

    def compose
      raise "No template set for #{view_name}, this is bad." if @template.nil?

      begin
        built_template = ERB.new(@template, trim_mode: '%<>')
        results = built_template.result_with_hash(@data)
      rescue NameError => e
        # If a data element isn't include for the template, add it to the data hash and then compose again.
        # This is so we don't error out if a variable hasn't been set yet.
        @data[e.name] = ''
        results = compose_template
      end

      results
    end
  end
end
