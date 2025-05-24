# frozen_string_literal: true

module LycanUi
  class Avatar < Component
    attr_reader :args, :fallback

    FALLBACK_CLASSES = <<~CLASSES.squish
      relative flex items-center justify-center h-10 w-10 shrink-0 overflow-hidden
      rounded-full bg-secondary-400 shadow-lg
    CLASSES

    def initialize(*args, fallback: nil, **attributes)
      @args = args
      @fallback = fallback

      if fallback.present?
        super(attributes, class: FALLBACK_CLASSES, data: { controller: "avatar" })
      else
        super(attributes, class: "rounded-full h-10 w-10 object-cover")
      end
    end

    def template
      if fallback.present?
        tag.div(**attributes) do
          concat(tag.div(fallback, class: "text-on-secondary font-medium", data: { avatar_target: "fallback" }))
          concat(image_tag(
            *args,
            class: "absolute w-full h-full object-cover shadow-lg",
            data: { action: "error->avatar#showFallback load->avatar#hideFallback", avatar_target: "image" },
          ))
        end
      else
        image_tag(*args, **attributes)
      end
    end
  end
end
