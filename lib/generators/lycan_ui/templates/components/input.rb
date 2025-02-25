# frozen_string_literal: true

module LycanUi
  class Input < Component
    attr_reader :object_name, :method, :type

    DEFAULT_CLASSES = "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"

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
