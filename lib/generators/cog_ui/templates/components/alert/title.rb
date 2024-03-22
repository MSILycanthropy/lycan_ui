# frozen_string_literal: true

class Alert::Title < CogUiComponent
  erb_template <<~ERB
    <%%= tag.h5(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = merge_classes("mb-1 font-medium leading-none tracking-tight", attributes[:class])

    super(**attributes)
  end
end
