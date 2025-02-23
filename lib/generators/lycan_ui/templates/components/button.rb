# frozen_string_literal: true

class Button < Component
  attr_accessor :content

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

  # TODO: Allow `as` option so we can do cool stuff like render link_to with
  # this
  def initialize(content = nil, variant: :primary, **attributes)
    @content = content

    super(attributes, class: [ DEFAULT_CLASSES, VARIANT_CLASSES[variant] ])
  end

  def template(&block)
    tag.button(**attributes) do
      determine_content(content, &block)
    end
  end
end
