# frozen_string_literal: true

class Checkbox < LycanUiComponent
  attr_accessor :object_name, :method, :checked_value, :unchecked_value

  erb_template <<~ERB
    <%%= check_box(object_name, method, attributes, checked_value, unchecked_value) %>
  ERB

  def initialize(object_name, method, attributes = {}, checked_value = "1", unchecked_value = "0")
    @object_name = object_name
    @method = method
    @checked_value = checked_value
    @unchecked_value = unchecked_value

    attributes[:class] = class_names(
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
