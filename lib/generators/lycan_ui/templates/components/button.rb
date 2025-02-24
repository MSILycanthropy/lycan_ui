# frozen_string_literal: true

module LycanUi
  class Button < Component
    attr_accessor :content, :as_child

    DEFAULT_CLASSES = <<~CLASSES.squish
      cursor-pointer inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium
      transition-colors disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2
    CLASSES

    VARIANT_CLASSES = {
      primary:
        "bg-primary text-on-primary hover:bg-primary/80",
      secondary:
        "bg-secondary text-on-secondary hover:bg-secondary/80 h-10 px-4 py-2",
      danger:
        "bg-danger text-on-danger hover:bg-danger/80 h-10 px-4 py-2",
      outline:
        "border border-primary hover:bg-primary hover:text-on-primary h-10 px-4 py-2",
      ghost:
        "hover:bg-secondary/30 hover:text-on-secondary h-10 px-4 py-2",
      link:
        "underline-offset-4 decoration-accent hover:underline h-10 px-4 py-2",
      none: nil,
    }.freeze

    def initialize(content = nil, variant: :primary, as_child: false, **attributes)
      @content = content
      @as_child = as_child

      super(attributes, type: :button, class: [ DEFAULT_CLASSES, VARIANT_CLASSES[variant] ])
    end

    def template(&block)
      return yield attributes if as_child

      tag.button(**attributes) do
        determine_content(content, &block)
      end
    end
  end
end
