# frozen_string_literal: true

module LycanUi
  class Textarea < Component
    attr_reader :object_name, :method

    DEFAULT_CLASSES = <<~CLASSES.squish
      flex min-h-20 w-full rounded-md bg-surface text-on-surface
      px-3 py-2 text-base placeholder:text-on-surface/50 md:text-sm
      focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent
      disabled:cursor-not-allowed disabled:opacity-50
    CLASSES

    def initialize(object_name, method, options = {})
      @object_name = object_name
      @method = method

      super(options, class: DEFAULT_CLASSES)
    end

    def template
      text_area(object_name, method, **attributes)
    end
  end
end
