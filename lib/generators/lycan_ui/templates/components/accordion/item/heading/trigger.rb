# frozen_string_literal: true

class Accordion::Item::Heading::Trigger < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.button(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(controls:, **attributes)
    attributes[:type] = :button

    disabled = attributes[:disabled]

    attributes[:data] =
      merge_data(
        attributes,
        data: { accordion__item_target: :trigger, action: "click->accordion--item#toggle" },
      )
    attributes[:aria] = merge_aria(attributes, aria: { expanded: false, controls:, disabled: })

    super(**attributes)
  end
end
