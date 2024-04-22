# frozen_string_literal: true

class Avatar::Fallback < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes({  data: { avatar_target: :fallback }  }, attributes)
    attributes[:class] = class_names("col-start-1 row-start-1", attributes[:class])

    super(**attributes)
  end
end
