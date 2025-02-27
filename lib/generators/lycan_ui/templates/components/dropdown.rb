# frozen_string_literal: true

module LycanUi
  class Dropdown < Component
    def initialize(**attributes)
      super(attributes, data: { controller: "dropdown" })
    end

    def template(&block)
      tag.div(**attributes, &block)
    end

    def trigger(content = nil, **trigger_attributes, &block)
      final_attributes = merge_attributes(
        trigger_attributes,
        data: { dropdown_target: "trigger", action: "dropdown#toggle" },
        aria: { has_popup: true, expanded: false },
      )

      render(Button.new(**final_attributes)) { determine_content(content, &block) }
    end

    def content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        role: "menu",
        hidden: true,
        data: { dropdown_target: "content" },
      )

      tag.div(**final_attributes, &)
    end

    def title(**title_attributes, &)
      tag.div(**title_attributes, &)
    end

    def separator
      tag.div
    end

    def navigation_item(name = nil, options = nil, html_options = nil, &)
      link_to(name, options, html_options, &)
    end

    def action_item(name = nil, options = nil, html_options = nil, &)
      button_to(name, options, html_options, &)
    end
  end
end
