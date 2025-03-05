# frozen_string_literal: true

module LycanUi
  class Tabs < Component
    attr_reader :default

    def initialize(default:, **attributes)
      @default = default

      super(attributes, data: { controller: "tabs" })
    end

    def template(&)
      @prefix = lycan_ui_id

      tag.div(**attributes) { yield self }
    end

    def list(**list_attributes, &)
      final_attributes = merge_attributes(
        list_attributes,
        role: "tablist",
        data: { action: "keydown.home->tabs#selectFirst keydown.end->tabs#selectLast" },
      )

      tag.div(**final_attributes, &)
    end

    def tab(name, content = nil, **tab_attributes, &block)
      selected = default == name
      final_attributes = merge_attributes(
        tab_attributes,
        role: "tab",
        type: "button",
        id: tab_identifier(name),
        data: {
          tabs_target: "tab",
          tabs_name_param: name,
          action: "tabs#select keydown.right->tabs#nextTab:self keydown.left->tabs#prevTab:self",
        },
        aria: { selected:, controls: panel_identifier(name) },
        tabindex: selected ? "0" : "-1",
      )

      tag.button(**final_attributes) { determine_content(content, &block) }
    end

    def panel(name, **panel_attributes, &)
      selected = default == name

      final_attributes = merge_attributes(
        panel_attributes,
        role: "tabpanel",
        id: panel_identifier(name),
        data: { tabs_target: "panel", name: },
        aria: { labelledby: tab_identifier(name) },
        hidden: !selected,
        tabindex: 0,
      )

      tag.div(**final_attributes, &)
    end

    private

    def tab_identifier(name)
      "#{@prefix}-tab-#{name}"
    end

    def panel_identifier(name)
      "#{@prefix}-panel-#{name}"
    end
  end
end
