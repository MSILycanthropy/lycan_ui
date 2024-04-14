# frozen_string_literal: true

class Table::Foot < LycanUiComponent
  renders_many :cells, ->(**attributes) {
    attributes[:class] = class_names("p-4 align-middle", attributes[:class])

    Table::Cell.new(**attributes)
  }

  erb_template <<~ERB
    <%%= tag.tfoot(**attributes) do %>
      <tr class="border-t border-black/75 transition-colors hover:bg-black/10">
        <%% cells.each do |cell| %>
          <%%= cell %>
        <%% end %>
      </tr>
    <%% end %>
  ERB

  def initialize(**attributes)
    super(**attributes)
  end
end
