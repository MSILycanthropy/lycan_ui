# frozen_string_literal: true

class Avatar::Fallback < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes(
      {
        data: { avatar_target: :fallback },
      },
      attributes,
    )

    super(**attributes)
  end
end
