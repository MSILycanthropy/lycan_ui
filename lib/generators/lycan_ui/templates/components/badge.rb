# frozen_string_literal: true

module LycanUi
  class Badge < Component
    attr_reader :content

    DEFAULT_CLASSES = <<~CLASSES.squish
      inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors
      focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2
    CLASSES

    VARIANT_CLASSES = {
      primary: "border-transparent bg-primary text-on-primary hover:bg-primary/80",
      secondary: "border-transparent bg-secondary text-on-secondary hover:bg-secondary/80",
      outline: "border-primary",
      danger: "border-transparent bg-danger text-on-danger hover:bg-danger/80",
    }.freeze

    def initialize(content = nil, variant: :primary, **attributes)
      @content = content

      super(attributes, class: [ DEFAULT_CLASSES, VARIANT_CLASSES[variant] ])
    end

    def template(&block)
      tag.div(**attributes) { determine_content(content, &block) }
    end
  end
end
