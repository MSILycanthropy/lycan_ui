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

    def content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        role: "menu",
        hidden: true,
        class: "absolute",
        aria: { labelledby: @labelledby },
        data: { dropdown_target: "content" },
      )

      tag.div(id: @controls, **final_attributes, &)
    end

    def title(content = nil, **title_attributes, &block)
      tag.div(**title_attributes) { determine_content(content, &block) }
    end

    def separator
      tag.div
    end

    def item(name = nil, options = nil, html_options = nil, &)
      html_options ||= {}
      disabled = html_options.delete(:disabled)

      html_options = merge_attributes(
        html_options,
        class: "block",
        role: "menuitem",
        tabindex: "-1",
        aria: { disabled: },
        data: {
          dropdown_target: "item",
          action: "dropdown#close mouseenter->dropdown#focusItem mouseleave->dropdown#focusTrigger",
        })

      link_to(name, options, html_options, &)
    end

    def action(name = nil, options = nil, html_options = nil, &block)
      html_options = merge_attributes(
        html_options || {},
        role: "menuitem",
        tabindex: "-1",
        data: {
          dropdown_target: "item",
          action: "dropdown#close mouseenter->dropdown#focusItem mouseleave->dropdown#focusTrigger", },
      )

      button_to(options, html_options) { determine_content(name, &block) }
    end
  end
end
