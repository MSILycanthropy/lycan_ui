# frozen_string_literal: true

class Label < CogUiComponent
  attr_accessor :form, :name, :text

  erb_template <<~ERB
    <% if content.present? %>
      <%= form.label name, **attributes do %>
        <%= content %>
      <% end %>
    <% else %>
      <%= form.label name, text, **attributes %>
    <% end %>
  ERB

  def initialize(form:, name:, text: nil, **attributes)
    @form = form
    @name = name
    @text = text

    attributes[:class] = merge_classes(
      "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
      attributes[:class],
    )

    super(**attributes)
  end
end
