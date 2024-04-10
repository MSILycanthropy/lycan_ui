# frozen_string_literal: true

class Checkbox < CogUiComponent
  attr_accessor :form, :name, :on, :off

  erb_template <<~ERB
    <%%= form.check_box(name, attributes, on, off) %>
  ERB

  def initialize(form:, name:, on: "1", off: "0", **attributes)
    @form = form
    @name = name
    @on = on
    @off = off

    attributes[:class] = merge_classes(
      "appearance-none checkbox cursor-pointer rounded-sm disabled:opacity-50 disabled:cursor-not-allowed " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "indeterminate:motion-safe:animate-[checked_250ms_ease-out] " \
        "checked:motion-safe:animate-[checked_250ms_ease-out] " \
        "w-4 h-4 border border-black ",
      attributes[:class],
    )

    super(**attributes)
  end
end
