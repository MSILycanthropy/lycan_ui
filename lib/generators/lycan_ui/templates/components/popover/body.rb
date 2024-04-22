# frozen_string_literal: true

class Popover::Body < LycanUiComponent
  attr_accessor :arrow

  erb_template <<~ERB
    <%%= tag.dialog(**attributes) do %>
      <%%= content %>

      <%%= tag.div(data: { popover_target: :arrow }, class: "absolute -top-1 bg-black rotate-45 size-2") %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes({ data: { popover_target: :body }  }, attributes)

    attributes[:class] = class_names(
      "m-0 absolute rounded-md bg-black p-4 z-50 text-white shadow-md outline-none " \
        "[&[open]:not([data-closing])]:animate-in data-[closing]:animate-out data-[closing]:fade-out-0 " \
        "[&[open]:not([data-closing])]:fade-in-0 data-[closing]:zoom-out-95 " \
        "[&[open]:not([data-closing])]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 " \
        "data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 " \
        "data-[side=top]:slide-in-from-bottom-2",
      attributes[:class],
    )

    super(**attributes)
  end
end
