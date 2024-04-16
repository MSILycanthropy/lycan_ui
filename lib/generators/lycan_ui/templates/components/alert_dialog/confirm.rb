# frozen_string_literal: true

class AlertDialog::Confirm < LycanUiComponent
  erb_template <<~ERB
    <%%= render Button.new(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes({ data: { action: "alert-dialog#confirm" } }, attributes)

    super(**attributes)
  end
end
