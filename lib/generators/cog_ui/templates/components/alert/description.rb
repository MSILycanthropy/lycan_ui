# frozen_string_literal: true

class Alert::Description < CogUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = merge_classes("text-sm [&_p]:leading-relaxed", attributes[:class])

    super(**attributes)
  end
end
