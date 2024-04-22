# frozen_string_literal: true

class Popover < LycanUiComponent
  attr_accessor :id

  renders_one :trigger, ->(**attributes) { Trigger.new(aria_controls: id, **attributes) }
  renders_one :body, ->(**attributes) { Body.new(id:, **attributes) }

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= trigger %>
      <%%= body %>
    <%% end %>
  ERB

  PLACEMENTS =  [
    "top",
    "top-start",
    "top-end",
    "right",
    "right-start",
    "right-end",
    "bottom",
    "bottom-start",
    "bottom-end",
    "left",
    "left-start",
    "left-end",
    "auto",
  ].freeze

  def initialize(placement: "bottom", **attributes)
    placement = placement.to_s.dasherize

    validates_argument_in(placement, PLACEMENTS)

    attributes[:data] = data_attributes(
      { data: { controller: :popover, popover_placement_value: placement } },
      attributes,
    )

    @id = generate_id

    super(**attributes)
  end
end
