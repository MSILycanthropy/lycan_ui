# frozen_string_literal: true

module LycanUi
  class Radio < Component
    attr_reader :object_name, :method, :tag_value

    DEFAULT_CLASSES = <<~CLASSES.squish
      flex size-4 cursor-pointer appearance-none items-center justify-center
      rounded-full border-2 border-surface motion-safe:transition-all
      before:size-0 before:rounded-full before:bg-accent
      checked:border-accent checked:before:size-2
      motion-safe:before:transition-all
    CLASSES

    def initialize(object_name, method, tag_value, options = {})
      @object_name = object_name
      @method = method
      @tag_value = tag_value

      super(options, class: DEFAULT_CLASSES)
    end

    def template
      radio_button(object_name, method, tag_value, **attributes)
    end
  end
end
