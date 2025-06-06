# frozen_string_literal: true

module LycanUi
  class Checkbox < Component
    attr_reader :object_name, :method, :checked_value, :unchecked_value

    DEFAULT_CLASSES = <<~CLASSES.squish
      appearance-none size-4 border border-accent rounded  motion-safe:transition-all
      ease-[ease] relative cursor-pointer
      after:top-[45%] after:left-1/2 after:w-1.5 after:h-2.5 after:opacity-0
      checked:bg-accent checked:border-transparent checked:scale-110 after:absolute
      after:border-r-2 after:border-b-2 after:border-surface-50 dark:after:border-surface-950
      after:-translate-x-1/2 after:-translate-y-1/2 after:rotate-45 after:scale-0
      after:transition-transform checked:after:scale-100 checked:after:opacity-100
      disabled:opacity-65 disabled:cursor-not-allowed
    CLASSES

    def initialize(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
      @object_name = object_name
      @method = method
      @checked_value = checked_value
      @unchecked_value = unchecked_value

      super(options, class: DEFAULT_CLASSES)
    end

    def template
      checkbox(object_name, method, attributes, checked_value, unchecked_value)
    end
  end
end
