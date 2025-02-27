# frozen_string_literal: true

module LycanUi
  class Label < Component
    attr_reader :object_name, :method, :content

    DEFAULT_CLASSES = "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"

    def initialize(object_name, method, content_or_options = nil, options = nil)
      @object_name = object_name
      @method = method

      attributes = options

      if content_or_options.is_a?(Hash)
        attributes = content_or_options
        @content = nil
      else
        attributes = options || {}
        @content = content_or_options
      end

      super(attributes, class: DEFAULT_CLASSES)
    end

    def render_in(view_context, &)
      view_context.label(object_name, method, content, **attributes, &)
    end
  end
end
