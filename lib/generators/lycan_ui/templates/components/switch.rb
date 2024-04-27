# frozen_string_literal: true

class Switch < LycanUiComponent
  attr_accessor :object_name, :method, :checked_value, :unchecked_value

  erb_template <<~ERB
    <%%= check_box(object_name, method, attributes, checked_value, unchecked_value) %>
  ERB

  def initialize(object_name, method, attributes = {}, checked_value = "1", unchecked_value = "0")
    @object_name = object_name
    @method = method
    @checked_value = checked_value
    @unchecked_value = unchecked_value

    attributes[:role] = :switch

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
