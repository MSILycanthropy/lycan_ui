# frozen_string_literal: true

class Table::Body < LycanUiComponent
  renders_many :rows, "Row"

  erb_template <<~ERB
    <%%= tag.tbody(**attributes) do %>
      <%% rows.each do |row| %>
        <%%= row %>
      <%% end %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names("[&_tr:last-child]:border-0", attributes[:class])

    super(**attributes)
  end
end
