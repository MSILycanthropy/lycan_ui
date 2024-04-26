# frozen_string_literal: true

class Label < LycanUiComponent
  attr_accessor :object_name, :method, :text

  erb_template <<~ERB
    <%% if content.present? %>
      <%%= label object_name, method, **attributes do %>
        <%%= content %>
      <%% end %>
    <%% else %>
      <%%= label object_name, method, text, **attributes %>
    <%% end %>
  ERB

  def initialize(object_name, method, text = nil, **attributes)
    @object_name = object_name
    @method = method
    @text = text

    attributes[:class] = class_names(
      "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
      attributes[:class],
    )

    super(**attributes)
  end
end
