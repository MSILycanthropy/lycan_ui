class Avatar::Image < CogUi::Component
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

    super(alt:, loading:, **attributes)
  end
end
