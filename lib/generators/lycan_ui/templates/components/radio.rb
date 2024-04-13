# frozen_string_literal: true

class Radio < LycanUiComponent
  attr_accessor :form, :name, :value

  erb_template <<~ERB
    <%%= form.radio_button(name, value, attributes) %>
  ERB

  def initialize(form:, name:, value:, **attributes)
    @form = form
    @name = name
    @value = value

    attributes[:class] = merge_classes(
      "appearance-none radio cursor-pointer rounded-full disabled:opacity-50 disabled:cursor-not-allowed " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "checked:bg-black checked:motion-safe:animate-[radio_250ms_ease-out] " \
        "w-4 h-4 border border-black",
      attributes[:class],
    )

    super(**attributes)
  end
end
