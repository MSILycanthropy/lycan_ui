# frozen_string_literal: true

class AlertDialog::Description < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.p(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names("text-sm text-black/90", attributes[:class])

    super(**attributes)
  end
end
