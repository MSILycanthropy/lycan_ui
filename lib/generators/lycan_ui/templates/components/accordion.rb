# frozen_string_literal: true

module LycanUi
  class Accordion < Component
    attr_reader :name, :multiple

    def initialize(multiple: false, **attributes)
      @multiple = multiple

      action = <<~ACTION.squish
        keydown.up->accordion#focusPrevious:prevent keydown.down->accordion#focusNext:prevent
        keydown.home->accordion#focusFirst:prevent keydown.end->accordion#focusLast:prevent
      ACTION

      super(attributes, data: { controller: "accordion", action: })
    end

    def template(&)
      @name = lycan_ui_id unless multiple

      tag.div(**attributes) { yield self }
    end

    ITEM_CLASSES = <<~CLASSES.squish
      border-b border-surface interpolate-keywords details:h-0 details-open:h-auto
      details:overflow-hidden details:text-sm details:motion-safe:transition-all
      details:duration-200 details:ease-out details:transition-discrete
      disabled:opacity-50 disabled:pointer-events-none
      open:[&>summary>svg]:rotate-180
    CLASSES

    def item(open: false, **item_attributes, &)
      final_attributes = merge_attributes(item_attributes, open:, class: ITEM_CLASSES, name:)

      tag.details(**final_attributes, &)
    end

    TRIGGER_CLASSES = <<~CLASSES.squish
      cursor-pointer flex flex-1 items-center justify-between py-4 font-medium
      transition-all underline-offset-4 hover:underline decoration-accent
    CLASSES
    def trigger(content = nil, icon: "chevron-down", **trigger_attributes, &block)
      final_attributes = merge_attributes(
        trigger_attributes,
        class: TRIGGER_CLASSES,
        data: { accordion_target: "item" },
      )

      tag.summary(**final_attributes) do
        safe_join([
          determine_content(content, &block),
          icon.present? ? lucide_icon(icon, class: "size-4 shrink-0 transition-transform duration-200") : nil,
        ].compact)
      end
    end

    def content(**content_attributes, &)
      final_attributes = merge_attributes(content_attributes, class: "pb-4")

      tag.div(**final_attributes, &)
    end
  end
end
