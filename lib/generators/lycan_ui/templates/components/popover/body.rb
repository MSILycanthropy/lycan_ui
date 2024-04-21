# frozen_string_literal: true

class Popover::Body < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.dialog(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes(
      { data: { popover_target: :body }  },
      attributes,
    )

    attributes[:class] = class_names(
      "m-0 absolute",
      attributes[:class],
    )

    super(**attributes)
  end
end
