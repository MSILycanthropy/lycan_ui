# frozen_string_literal: true

class Alert::Title < ApplicationComponent
  erb_template <<~ERB
    <%%= tag.h5(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names("mb-1 font-medium leading-none tracking-tight", attributes[:class])

    super(**attributes)
  end
end
