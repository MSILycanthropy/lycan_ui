# frozen_string_literal: true

class Table::Body::Row < ApplicationComponent
  renders_many :cells, "Table::Cell"

  erb_template <<~ERB
    <%%= tag.tr(**attributes) do %>
      <%% cells.each do |cell| %>
        <%%= cell %>
      <%% end %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names(
      "border-b border-black/75 transition-colors hover:bg-black/10",
      attributes[:class],
    )

    super(**attributes)
  end
end
