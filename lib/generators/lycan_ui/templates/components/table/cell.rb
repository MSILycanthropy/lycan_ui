# frozen_string_literal: true

class Table::Cell < ApplicationComponent
  attr_reader :type

  erb_template <<~ERB
    <%%= tag.td(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names("p-4 align-middle", attributes[:class])

    super(**attributes)
  end
end
