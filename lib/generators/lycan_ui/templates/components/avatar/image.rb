# frozen_string_literal: true

class Avatar::Image < LycanUiComponent
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
