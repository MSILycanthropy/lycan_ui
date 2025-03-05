# frozen_string_literal: true

module LycanUi
  class Alert < Component
    DEFAULT_CLASSES = <<~CLASSES.squish
      relative w-full rounded-lg border p-4 [&>svg~*]:pl-7 [&>svg+div]:translate-y-[-3px]
      [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-3.5
    CLASSES

    VARIANT_CLASSES = {
      primary: "border-on-surface",
      danger: "border-danger bg-danger-500 text-on-danger [&>svg]:text-on-danger",
    }.freeze

    def initialize(variant: :primary, **attributes)
      super(attributes, class: [ DEFAULT_CLASSES, VARIANT_CLASSES[variant] ])
    end

    def template(&)
      tag.div(**attributes) { yield self }
    end

    def title(content = nil, **title_attributes, &block)
      final_attributes = merge_attributes(title_attributes, class: "mb-1 font-medium leading-none tracking-tight")

      tag.div(**final_attributes) { determine_content(content, &block) }
    end

    def description(content = nil, **description_attributes, &block)
      final_attributes = merge_attributes(description_attributes, class: "text-sm [&_p]:leading-relaxed")

      tag.div(**final_attributes) { determine_content(content, &block) }
    end
  end
end
