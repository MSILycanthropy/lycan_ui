# frozen_string_literal: true

module LycanUi
  class Accordion < Component
    attr_reader :name, :multiple

    def initialize(multiple: false, **attributes)
      @multiple = multiple

      action = <<~ACTION.squish
        keydown.up->accordion#focusPrevious keydown.down->accordion#focusNext
        keydown.home->accordion#focusFirst keydown.end->accordion#focusLast
      ACTION

      super(attributes, data: { controller: "accordion", action: })
    end

    def template(&)
      @name = lycan_ui_id unless multiple

      tag.div(**attributes) { yield self }
    end

    ITEM_CLASSES = <<~CLASSES.squish
      border-b border-secondary interpolate-keywords details:h-0 details-open:h-auto
      details:overflow-hidden details:text-sm details:motion-safe:transition-all
      details:duration-200 details:ease-out details:transition-discrete
      disabled:opacity-50 disabled:pointer-events-none
    CLASSES

    def item(open: false, **item_attributes, &)
      final_attributes = merge_attributes(item_attributes, open:, class: ITEM_CLASSES, name:)

      tag.details(**final_attributes, &)
    end

    TRIGGER_CLASSES = <<~CLASSES.squish
      cursor-pointer flex flex-1 items-center justify-between py-4 font-medium
      transition-all underline-offset-4 hover:underline decoration-accent
    CLASSES

    def trigger(**trigger_attributes, &)
      final_attributes = merge_attributes(
        trigger_attributes,
        class: TRIGGER_CLASSES,
        data: { accordion_target: "item" },
      )

      tag.summary(**final_attributes, &)
    end

    def content(**content_attributes, &)
      final_attributes = merge_attributes(content_attributes, class: "pb-4")

      tag.div(**final_attributes, &)
    end
  end
end
