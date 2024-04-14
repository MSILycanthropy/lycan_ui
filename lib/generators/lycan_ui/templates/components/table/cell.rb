# frozen_string_literal: true

class Table::Cell < LycanUiComponent
  attr_reader :type

  erb_template <<~ERB
    <%%= tag.send(cell_tag, **attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  TYPES = [ :data, :header ]

  def initialize(type: :data, **attributes)
    validates_argument_in(type, TYPES)

    @type = type

    super(**attributes)
  end

  private

  def cell_tag
    case type
    when :data
      :td
    when :header
      :th
    end
  end
end
