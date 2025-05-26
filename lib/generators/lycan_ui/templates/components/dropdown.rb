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

      tag.div(**attributes) do
        yield self

        concat(safe_join(@submenus)) if @submenus&.any?
      end
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
      data-[open=false]:invisible motion-safe:transition-[opacity_transform]
      will-change-[opacity,transform] duration-150
      data-[open=false]:opacity-0 opacity-100
      data-[open=false]:scale-95 scale-100
      data-[open=false]:data-[side=bottom]:-translate-y-2 translate-y-0
      data-[open=false]:data-[side=top]:translate-y-2
      data-[open=false]:data-[side=left]:translate-x-2
      data-[open=false]:data-[side=right]:-translate-x-2
    CLASSES
    def content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        role: "menu",
        class: CONTENT_CLASSES,
        aria: { labelledby: @labelledby },
        data: { open: false, dropdown_target: "content" },
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
    def submenu(id: lycan_ui_id, &block)
      @current_submenu_id = id

      yield @current_submenu_id

      @current_submenu_id = nil
    end

    SUBMENU_TRIGGER_ACTIONS = <<~ACTIONS.squish
      pointerenter->dropdown#focusItem pointerleave->dropdown#focusTrigger
      pointerenter->dropdown#openSubmenu keydown.right->dropdown#openSubmenu:prevent
      dropdown#openSubmenu
    ACTIONS
    def submenu_trigger(name = nil, **attributes, &block)
      final_attributes = merge_attributes(
        attributes,
        { class: "aria-expanded:bg-accent aria-expanded:text-on-accent" },
        class: ITEM_CLASSES,
        tabindex: "-1",
        role: "menuitem",
        aria: {
          has_popup: true,
          expanded: false,
          controls: @current_submenu_id,
        },
        data: {
          dropdown_target: "item",
          action: SUBMENU_TRIGGER_ACTIONS,
          dropdown_submenu_param: @current_submenu_id,
          submenu: @current_submenu_id,
        },
      )

      tag.button(**final_attributes) { determine_content(name, &block) }
    end

    def submenu_content(**content_attributes, &)
      final_attributes = merge_attributes(
        content_attributes,
        role: "menu",
        class: CONTENT_CLASSES,
        data: {
          dropdown_target: "submenu",
          action: "keydown->dropdown#submenuHandleKeydown",
          dropdown_submenu_param: @current_submenu_id,
          open: false,
        },
      )

      @submenus ||= []
      @submenus << tag.div(id: @current_submenu_id, **final_attributes, &)

      # this must return nil to ensure the submenus are rerendered outside
      # the original dropdown menu
      nil
    end

    def link(name = nil, options = nil, html_options = nil, &block)
      html_options, options, name = options, name, block if block_given?

      html_options ||= {}
      disabled = html_options.delete(:disabled)
      close = html_options.delete(:close)
      close = true if close.nil?

      html_options = merge_attributes(
        html_options,
        class: ITEM_CLASSES,
        role: "menuitem",
        tabindex: "-1",
        aria: { disabled: },
      )

      close_action = close ? "dropdown#close" : ""
      html_options = if @current_submenu_id.present?
       merge_attributes(html_options, data: {
         dropdown_target: "submenuItem",
         action: "pointerenter->dropdown#focusItem pointerleave->dropdown#focusSubmenuTrigger #{close_action}",
         dropdown_submenu_param: @current_submenu_id,
         submenu: @current_submenu_id,
       })
      else
        merge_attributes(html_options, data: {
          dropdown_target: "item",
          action: "pointerenter->dropdown#focusItem pointerleave->dropdown#focusTrigger #{close_action}",
        })
      end

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
      close = html_options.delete(:close)
      close = true if close.nil?

      html_options = merge_attributes(
        html_options,
        role: "menuitem",
        class: ITEM_CLASSES,
        tabindex: "-1",
        disabled:,
      )

      close_action = close ? "dropdown#close" : ""
      html_options = if @current_submenu_id.present?
       merge_attributes(html_options, data: {
         dropdown_target: "submenuItem",
         action: "pointerenter->dropdown#focusItem pointerleave->dropdown#focusSubmenuTrigger #{close_action}",
         dropdown_submenu_param: @current_submenu_id,
         submenu: @current_submenu_id,
       })
      else
        merge_attributes(html_options, data: {
          dropdown_target: "item",
          action: "pointerenter->dropdown#focusItem pointerleave->dropdown#focusTrigger #{close_action}",
        })
      end

      if block_given?
        button_to(options, html_options, &block)
      else
        button_to(name, options, html_options)
      end
    end

    def button(name = nil, close: true, disabled: false, **attributes, &block)
      close_action = close ? "dropdown#close" : ""

      attributes = merge_attributes(
        attributes,
        role: "menuitem",
        class: ITEM_CLASSES,
        tabindex: "-1",
        disabled:,
      )
      attributes = if @current_submenu_id.present?
       merge_attributes(attributes, data: {
         dropdown_target: "submenuItem",
         action: "pointerenter->dropdown#focusItem pointerleave->dropdown#focusSubmenuTrigger #{close_action}",
         dropdown_submenu_param: @current_submenu_id,
         submenu: @current_submenu_id,
       })
      else
        merge_attributes(attributes, data: {
          dropdown_target: "item",
          action: "pointerenter->dropdown#focusItem pointerleave->dropdown#focusTrigger #{close_action}",
        })
      end

      tag.button(**attributes) { determine_content(name, &block) }
    end
  end
end
