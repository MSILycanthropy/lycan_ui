# frozen_string_literal: true

class Accordion < CogUiComponent
  renders_many :items, Accordion::Item

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%% items.each do |item| %>
        <%%= item %>
      <%% end %>
    <%% end %>
  ERB

  ACTIONS = [
    "accordion--item:opened->accordion#closeOthers",
    "keydown.up->accordion#focusPrevious",
    "keydown.down->accordion#focusNext",
    "keydown.home->accordion#focusFirst",
    "keydown.end->accordion#focusLast",
  ].freeze

  def initialize(multiple: false, **attributes)
    @multiple = multiple

    attributes[:classes] = merge_classes(
      "p-4",
      attributes[:classes],
    )
    attributes[:data] = merge_data(
      {
        data: {
          action: ACTIONS.join(" "),
          accordion_accordion__item_outlet: "[data-controller='accordion--item']".html_safe,
          accordion_multiple_value: multiple,
        },
      },
      attributes,
    )

    super(**attributes)
  end
end
