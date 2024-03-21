class Avatar::Image < CogUiComponent
  erb_template <<~ERB
    <%%= tag.img(**attributes) %>
  ERB

  def initialize(alt: nil, loading: nil, **attributes)
    attributes[:data] = merge_data(
      {
        data: {
          avatar_target: "avatar",
        },
      },
      attributes,
    )
    attributes[:class] = merge_classes(
      "object-cover",
      attributes[:class],
    )

    super(alt:, loading:, **attributes)
  end
end
