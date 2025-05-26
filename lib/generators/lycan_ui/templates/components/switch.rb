# frozen_string_literal: true

module LycanUi
  class Switch < Component
    attr_reader :object_name, :method, :checked_value, :unchecked_value

    DEFAULT_CLASSES = <<~CLASSES.squish
      appearance-none cursor-pointer rounded-full disabled:opacity-50 disabled:cursor-not-allowed
      w-10 h-5 bg-background shadow-switch checked:shadow-switch-checked
      motion-safe:transition-all motion-safe:duration-500 motion-safe:ease-in-out
    CLASSES

    def initialize(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
      @object_name = object_name
      @method = method
      @checked_value = checked_value
      @unchecked_value = unchecked_value

      super(options, role: "switch", class: DEFAULT_CLASSES)
    end

    def template
      checkbox(object_name, method, attributes, checked_value, unchecked_value)
    end
  end
end
