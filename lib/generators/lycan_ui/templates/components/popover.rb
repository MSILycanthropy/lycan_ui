# frozen_string_literal: true

module LycanUi
  class Popover < Component
    def initialize(**attributes)
      super(
        attributes,
        data: {
          controller: "popover",
        }
      )
    end

    def template(&block)
      @labelledby = lycan_ui_id
      @controls = lycan_ui_id

      tag.div(**attributes) { yield self }
    end

    def trigger(content = nil, **trigger_attributes, &block)
      final_attributes = merge_attributes(
        trigger_attributes,
        data: { popover_target: "trigger", action: "popover#toggle" },
        aria: { has_popup: true, expanded: false, controls: @controls },
      )

      render(Button.new(content, id: @labelledby, **final_attributes), &block)
    end

    CONTENT_CLASSES = <<~CLASSES.squish
      absolute z-50 min-w-32 overflow-y-auto overflow-x-hidden shadow-md
      bg-background text-on-background border border-surface p-4 rounded-md
      not-open:invisible not-open:block transition-[opacity_transform] will-change-[opacity,transform]
      duration-150
      not-open:opacity-0 opacity-100
      not-open:scale-95 scale-100
      not-open:data-[side=bottom]:-translate-y-2
      not-open:data-[side=top]:translate-y-2
      not-open:data-[side=left]:translate-x-2
      not-open:data-[side=right]:-translate-x-2
    CLASSES
    def content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        class: CONTENT_CLASSES,
        data: { popover_target: "content" },
      )

      tag.dialog(id: @controls, **final_attributes, &)
    end
  end
end
