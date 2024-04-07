# frozen_string_literal: true

class Switch < CogUiComponent
  attr_accessor :form, :name, :type

  erb_template <<~ERB
    <%%= form.check_box(name, **attributes) %>
  ERB

  def initialize(form:, name:, type: :text, **attributes)
    @form = form
    @name = name
    @type = type

    attributes[:class] = merge_classes(
      "appearance-none cursor-pointer rounded-full disabled:opacity-50 disabled:cursor-not-allowed " \
        "w-10 h-5 bg-black shadow-[-1.25rem_0_0_2px_white_inset,0_0_0_2px_white_inset] " \
        "checked:bg-white checked:shadow-[1.25rem_0_0_2px_black_inset,0_0_0_2px_black_inset] " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "transition-all duration-300 ease-in-out border border-black",
      attributes[:class],
    )

    super(**attributes)
  end
end
