
# frozen_string_literal: true

class Skeleton < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      &nbsp;
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names(
      "animate-pulse rounded-md bg-neutral-700",
      attributes[:class],
    )

    super(**attributes)
  end
end
