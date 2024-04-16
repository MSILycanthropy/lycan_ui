# frozen_string_literal: true

class Accordion::Item::Heading < LycanUiComponent
  attr_accessor :disabled, :controls, :labelledby

  renders_one :trigger, ->(**attributes) {
    Trigger.new(disabled:, controls:, id: labelledby, **attributes)
  }

  erb_template <<~ERB
    <%%= tag.h2(**attributes) do %>
      <%%= trigger %>
    <%% end %>
  ERB

  def before_render
    with_trigger { content.to_s } unless trigger?
  end

  def initialize(disabled: false, controls:, labelledby:, **attributes)
    @disabled = disabled
    @controls = controls
    @labelledby = labelledby

    attributes[:aria] = aria_attributes(attributes, {})

    super(**attributes)
  end
end
