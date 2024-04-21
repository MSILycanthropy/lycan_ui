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

  def initialize(arrow: false, **attributes)
    attributes[:data] = data_attributes({ data: { controller: :popover } }, attributes)

    @id = generate_id

    super(**attributes)
  end
end
