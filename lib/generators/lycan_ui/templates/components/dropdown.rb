# frozen_string_literal: true

module LycanUi
  class Dropdown < Component
    def initialize(**attributes)
      super(attributes, data: { controller: "dropdown", action: "keydown->dropdown#handleKeydown" })
    end

    def template(&block)
      @labelledby = lycan_ui_id
      @controls = lycan_ui_id

      tag.div(**attributes, &block)
    end

    def trigger(content = nil, **trigger_attributes, &block)
      final_attributes = merge_attributes(
        trigger_attributes,
        data: { dropdown_target: "trigger", action: "dropdown#toggle" },
        aria: { has_popup: true, expanded: false, controls: @controls },
      )

      render(Button.new(id: @labelledby, **final_attributes)) { determine_content(content, &block) }
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
      html_options = merge_attributes(
        html_options || {},
        class: "block",
        role: "menuitem",
        tabindex: "-1",
        data: {
          dropdown_target: "item",
          action: "mouseenter->dropdown#focusItem mouseleave->dropdown#focusTrigger",
        })

      link_to(name, options, html_options, &)
    end

    def action(name = nil, options = nil, html_options = nil, &)
      options = merge_attributes(
        options || {},
        role: "menuitem",
        tabindex: "-1",
        data: { dropdown_target: "item", action: "mouseenter->dropdown#focusItem mouseleave->dropdown#focusTrigger" },
      )

      button_to(name, options, html_options, &)
    end
  end
end
