# frozen_string_literal: true

class AlertDialog::Confirm < ApplicationComponent
  erb_template <<~ERB
    <%%= render Button.new(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:type] = :button
    attributes[:data] = data_attributes({ data: { action: "alert-dialog#confirm" } }, attributes)

    super(**attributes)
  end
end
