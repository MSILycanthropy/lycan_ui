# frozen_string_literal: true

class Table::Head < LycanUiComponent
  renders_many :cells, ->(**attributes) {
    attributes[:type] ||= :header
    attributes[:scope] ||= :col
    attributes[:class] = class_names(
      "h-12 px-4 text-left align-middle font-medium",
      attributes[:class],
    )

    Table::Cell.new(**attributes)
  }

  erb_template <<~ERB
    <%%= tag.thead(**attributes) do %>
      <tr class="border-b border-black/75 transition-colors hover:bg-black/10">
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
