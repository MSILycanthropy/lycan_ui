# frozen_string_literal: true

module LycanUi
  class Input < Component
    attr_reader :object_name, :method, :type

    DEFAULT_CLASSES = <<~CLASSES
      flex h-10 w-full rounded-md px-3 py-2 text-sm bg-surface-50 dark:bg-surface-950 text-on-surface
      file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground
      focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent
      disabled:cursor-not-allowed disabled:opacity-50
    CLASSES

    def initialize(object_name, method, options = {})
      @object_name = object_name
      @method = method
      @type = options.delete(:type) || :text

      super(options, class: DEFAULT_CLASSES)
    end

    def template
      send("#{type}_field", object_name, method, **attributes)
    end
  end
end
