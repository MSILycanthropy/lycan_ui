# frozen_string_literal: true

class AlertDialog::Title < ApplicationComponent
  erb_template <<~ERB
    <%%= tag.h2(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names("text-lg font-semibold", attributes[:class])

    super(**attributes)
  end
end
