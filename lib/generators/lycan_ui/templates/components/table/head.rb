# frozen_string_literal: true

class Table::Head < ApplicationComponent
  renders_many :cells, "Cell"

  erb_template <<~ERB
    <%%= tag.thead(**attributes) do %>
      <tr class="border-b border-black/75">
        <%% cells.each do |cell| %>
          <%%= cell %>
        <%% end %>
      </tr>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names("[&_tr]:border-b", attributes[:class])

    super(**attributes)
  end
end
