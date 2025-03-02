# frozen_string_literal: true

module LycanUi
  class Button < Component
    attr_accessor :content, :as_child

    DEFAULT_CLASSES = <<~CLASSES.squish
      cursor-pointer inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium
      transition-colors disabled:pointer-events-none disabled:opacity-50
    CLASSES

    SIZE_CLASSES = {
      extra_small: "h-6 px-1 text-xs",
      small: "h-7 px-2 text-sm",
      medium: "h-10 px-4 text-base",
      large: "h-11 px-5 text-lg",
    }.freeze

    VARIANT_CLASSES = {
      primary:
        "bg-primary text-on-primary hover:bg-primary/80",
      secondary:
        "bg-secondary text-on-secondary hover:bg-secondary/80",
      danger:
        "bg-danger text-on-danger hover:bg-danger/80",
      outline:
        "border border-primary hover:bg-primary hover:text-on-primary",
      ghost:
        "hover:bg-secondary/30 hover:text-on-secondary",
      link:
        "underline-offset-4 decoration-accent hover:underline",
      none: nil,
    }.freeze

    def initialize(content = nil, size: :medium, variant: :primary, as_child: false, **attributes)
      @content = content
      @as_child = as_child

      super(attributes, type: :button, class: [ DEFAULT_CLASSES, VARIANT_CLASSES[variant], SIZE_CLASSES[size] ])
    end

    def template(&block)
      return yield attributes.except(:type) if as_child

      tag.button(**attributes) { determine_content(content, &block) }
    end
  end
end
