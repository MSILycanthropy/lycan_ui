# frozen_string_literal: true

module LycanUi
  class Collapsible < Component
    def initialize(**attributes)
      super(attributes, data: { controller: "collapsible" })
    end

    def template(&)
      @id = lycan_ui_id

      tag.div(**attributes) { yield self }
    end

    def trigger(content = nil, **trigger_attributes, &)
      final_attributes = merge_attributes(
        trigger_attributes,
        aria: { controls: @id, expanded: false },
        data: { collapsible_target: "trigger", action: "collapsible#toggle" },
      )

      ui.button(content, **final_attributes, &)
    end

    CONTENT_CLASSES = <<~CLASSES
      overflow-hidden interpolate-keywords transition-discrete starting:h-0 hidden:h-0 h-auto motion-safe:transition-all duration-300
    CLASSES
    def content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        id: @id,
        class: CONTENT_CLASSES,
        hidden: true,
        data: { collapsible_target: "content" },
      )

      tag.div(**final_attributes, &)
    end
  end
end
