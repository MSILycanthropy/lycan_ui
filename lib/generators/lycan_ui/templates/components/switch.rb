# frozen_string_literal: true

class Switch < LycanUiComponent
  attr_accessor :form, :name, :on, :off

  erb_template <<~ERB
    <%%= form.check_box(name, attributes, on, off) %>
  ERB

  def initialize(form:, name:, on: "1", off: "0", **attributes)
    @form = form
    @name = name
    @on = on
    @off = off

    attributes[:class] = class_names(
      "appearance-none cursor-pointer rounded-full disabled:opacity-50 disabled:cursor-not-allowed " \
        "w-10 h-5 bg-black shadow-[-1.25rem_0_0_2px_white_inset,0_0_0_2px_white_inset] " \
        "checked:bg-white checked:shadow-[1.25rem_0_0_2px_black_inset,0_0_0_2px_black_inset] " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "motion-safe:transition-all motion-safe:duration-300 motion-safe:ease-in-out border border-black",
      attributes[:class],
    )

    super(**attributes)
  end
end
