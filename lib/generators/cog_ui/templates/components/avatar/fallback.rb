class <Avatar::Fallback < CogUi::Component
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = merge_data(
      {
        data: { avatar_target: :fallback },
      },
      attributes,
    )

    super(**attributes)
  end
end
