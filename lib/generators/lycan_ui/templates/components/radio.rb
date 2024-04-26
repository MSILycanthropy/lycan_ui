# frozen_string_literal: true

class Radio < LycanUiComponent
  attr_accessor :object_name, :method, :value

  erb_template <<~ERB
    <%%= radio_button(object_name, method, value, attributes) %>
  ERB

  def initialize(object_name, method, value, **attributes)
    @object_name = object_name
    @method = method
    @value = value

    attributes[:class] = class_names(
      "appearance-none radio cursor-pointer rounded-full disabled:opacity-50 disabled:cursor-not-allowed " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "checked:bg-black checked:motion-safe:animate-[radio_250ms_ease-out] " \
        "w-4 h-4 border border-black",
      attributes[:class],
    )

    super(**attributes)
  end
end
