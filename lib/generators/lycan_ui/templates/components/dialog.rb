# frozen_string_literal: true

module LycanUi
  class Dialog < Component
    def initialize(open: false, **attributes)
      @open = open

      super(
        attributes,
        data: {
          controller: "dialog",
          dialog_topen_value: open,
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
        data: { dialog_target: "trigger", action: "dialog#open" },
        aria: { has_popup: true, expanded: false, controls: @controls },
      )

      render(Button.new(content, **final_attributes), &block)
    end

    CONTENT_CLASSES = <<~CLASSES.squish
      fixed left-1/2 top-1/2 z-50 open:grid max-w-lg -translate-x-1/2 -translate-y-1/2
      gap-4 border border-surface bg-background p-6 shadow-lg rounded-lg
      backdrop:bg-black/65 not-open:backdrop:hidden transition-[opacity_transform_display] transition-discrete
      starting:opacity-0 not-open:opacity-0 opacity-100
      starting:scale-95 not-open:scale-95 scale-100
      starting:-translate-y-[48%] not-open:-translate-y-[48%]
    CLASSES
    CLOSE_CLASSES = <<~CLASSES.squish
      absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background
      transition-opacity hover:opacity-100 focus-visible:outline-none focus-visible:ring-2
      focus-visible:ring-accent focus-visible:ring-offset-2
    CLASSES
    def content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        class: CONTENT_CLASSES,
        open: @open,
        aria: { labelledby: @labelledby },
        data: { dialog_target: "content" },
      )

      close_btn = tag.button(class: CLOSE_CLASSES, type: "button", data: { action: "dialog#close" }) do
        lucide_icon("x", class: "size-4")
      end

      tag.dialog(id: @controls, **final_attributes) do
        safe_join([ @view_context.capture(&), close_btn ])
      end
    end

    def header(**header_attributes, &)
      final_attributes = merge_attributes(
        header_attributes,
        class: "flex flex-col space-y-1.5 text-center sm:text-left",
      )

      tag.div(**final_attributes, &)
    end

    def title(content = nil, **title_attributes, &)
      final_attributes = merge_attributes(
        title_attributes,
        class: "text-lg font-semibold leading-none tracking-tight",
      )

      tag.h2(**final_attributes) { determine_content(content, &) }
    end

    def description(content = nil, **description_attributes, &)
      final_attributes = merge_attributes(
        description_attributes,
        id: @labelledby,
        class: "text-sm text-on-background/90",
      )

      tag.p(**final_attributes) { determine_content(content, &) }
    end

    def footer(**footer_attributes, &)
      final_attributes = merge_attributes(
        footer_attributes,
        class: "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
      )

      tag.div(**final_attributes, &)
    end
  end
end
