# frozen_string_literal: true

class Accordion::Item::Body < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes({ data: { accordion__item_target: "body" } }, attributes)

    super(**attributes)
  end
end
