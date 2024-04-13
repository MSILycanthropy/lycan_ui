# frozen_string_literal: true

class Accordion::Item::Body < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.div do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = merge_data(attributes, data: { accordion__item_target: "body" })

    super(**attributes)
  end
end
