# frozen_string_literal: true

class Alert::Description < ApplicationComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names("text-sm [&_p]:leading-relaxed", attributes[:class])

    super(**attributes)
  end
end
