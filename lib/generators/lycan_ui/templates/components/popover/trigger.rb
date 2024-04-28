# frozen_string_literal: true

class Popover::Trigger < ApplicationComponent
  erb_template <<~ERB
    <%%= render Button.new(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes(
      { data: { popover_target: :trigger, action: "click->popover#toggle" } },
      attributes,
    )

    attributes[:aria] = aria_attributes(
      { aria: { haspopup: :dialog, expanded: false } },
      attributes,
    )

    super(**attributes)
  end
end
