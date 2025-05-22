# frozen_string_literal: true

module LycanUi
  class Dropdown < Component
    def initialize(typeahead: true, **attributes)
      super(
        attributes,
        data: {
          controller: "dropdown",
          action: "keydown->dropdown#handleKeydown",
          dropdown_typeahead_value: typeahead,
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
        data: { dropdown_target: "trigger", action: "dropdown#toggle" },
        aria: { has_popup: true, expanded: false, controls: @controls },
      )

      render(Button.new(content, id: @labelledby, **final_attributes), &block)
    end

    CONTENT_CLASSES = <<~CLASSES.squish
      absolute z-50 min-w-32 overflow-y-auto overflow-x-hidden shadow-md
      bg-background text-on-background border border-surface p-1 rounded-md
    CLASSES
    def content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        role: "menu",
        hidden: true,
        class: CONTENT_CLASSES,
        aria: { labelledby: @labelledby },
        data: { dropdown_target: "content" },
      )

      tag.div(id: @controls, **final_attributes, &)
    end

    def title(content = nil, **title_attributes, &block)
      final_attributes = merge_attributes(title_attributes, { class: "px-2 py-1.5 text-sm font-semibold" })

      tag.div(**final_attributes) { determine_content(content, &block) }
    end

    def separator
      tag.div(role: "separator", aria_orientation: "horizontal", class: "-mx-1 my-1 h-px bg-surface")
    end

    def group(&block)
      tag.div(role: "group", &block)
    end

    ITEM_CLASSES = <<~CLASSES.squish
      relative flex w-full cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm
      outline-none transition-colors cursor-pointer focus:bg-accent focus:text-on-accent
      aria-disabled:pointer-events-none aria-disabled:opacity-50
      disabled:pointer-events-none disabled:opacity-50
      [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0
    CLASSES
    def item(name = nil, options = nil, html_options = nil, &block)
      html_options, options, name = options, name, block if block_given?

      html_options ||= {}
      disabled = html_options.delete(:disabled)

      html_options = merge_attributes(
        html_options,
        class: ITEM_CLASSES,
        role: "menuitem",
        tabindex: "-1",
        aria: { disabled: },
        data: {
          dropdown_target: "item",
          action: "dropdown#close mouseenter->dropdown#focusItem mouseleave->dropdown#focusTrigger",
        })


      if block_given?
        link_to(options, html_options, &block)
      else
        link_to(name, options, html_options)
      end
    end

    def action(name = nil, options = nil, html_options = nil, &block)
      html_options, options, name = options, name, block if block_given?
      html_options ||= {}

      disabled = html_options.delete(:disabled)

      html_options = merge_attributes(
        html_options,
        role: "menuitem",
        class: ITEM_CLASSES,
        tabindex: "-1",
        disabled:,
        data: {
          dropdown_target: "item",
          action: "dropdown#close mouseenter->dropdown#focusItem mouseleave->dropdown#focusTrigger", },
      )

      if block_given?
        button_to(options, html_options, &block)
      else
        button_to(name, options, html_options)
      end
    end
  end
end
