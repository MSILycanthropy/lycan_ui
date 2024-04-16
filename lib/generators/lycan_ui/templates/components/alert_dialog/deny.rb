# frozen_string_literal: true

class AlertDialog::Deny < LycanUiComponent
  erb_template <<~ERB
    <%%= render Button.new(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:variant] ||= :outline

    attributes[:data] = data_attributes({ data: { action: "alert-dialog#deny" } }, attributes)

    super(**attributes)
  end
end
