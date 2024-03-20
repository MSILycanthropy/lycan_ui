class <%= class_name %> < CogUiComponent
  renders_many :items, <%= class_name %>::Item

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%% items.each do |item| %>
        <%%= item %>
      <%% end %>
    <%% end %>
  ERB

  ACTIONS = [
    "<%= file_name.to_s.dasherize %>--item:opened-><%= file_name.to_s.dasherize %>#closeOthers",
    "keydown.up-><%= file_name.to_s.dasherize %>#focusPrevious",
    "keydown.down-><%= file_name.to_s.dasherize %>#focusNext",
    "keydown.home-><%= file_name.to_s.dasherize %>#focusFirst",
    "keydown.end-><%= file_name.to_s.dasherize %>#focusLast",
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
          <%= file_name.to_s.dasherize %>_<%= file_name.to_s.dasherize %>__item_outlet: "[data-controller='<%= file_name.to_s.dasherize %>--item']".html_safe,
          <%= file_name.to_s.dasherize %>_multiple_value: multiple,
        },
      },
      attributes,
    )

    super(**attributes)
  end
end
