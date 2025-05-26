# frozen_string_literal: true

module LycanUi
  class Select < Component
    attr_reader :object_name, :method, :choices, :options

    CLASSES = <<~CLASSES.squish
      appearance-none bg-background text-on-background rounded-md border border-surface
      px-3 py-2 pr-10 w-full focus:outline-none ring-primary ring-offset-2
      ring-offset-background focus-visible:ring-2 peer/select cursor-pointer
      scheme-light
    CLASSES
    def initialize(object_name, method, choices = nil, options = {}, html_options = {})
      @object_name = object_name
      @method = method
      @choices = choices
      @options = options

      super(html_options, class: CLASSES)
    end

    ICON_CLASSES = <<~CLASSES.squish
      size-4 self-center place-self-end mr-2 text-on-background
      pointer-events-none group-hover/select:text-on-background
      peer-open/select:rotate-180 motion-safe:transition-transform
    CLASSES
    def render_in(view_context, &)
      view_context.tag.div(class: "w-fit h-10 inline-grid *:[grid-area:1/1] group/select") do
        view_context.safe_join([
          view_context.select(object_name, method, choices, options, attributes, &),
          view_context.lucide_icon("chevron-down", class: ICON_CLASSES),
        ])
      end
    end
  end
end
